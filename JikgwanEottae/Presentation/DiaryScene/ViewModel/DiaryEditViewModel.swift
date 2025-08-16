//
//  DiaryEditViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/8/25.
//

// MARK: - 직관 일기 생성 및 편집을 담당하는 뷰 모델입니다.

import Foundation

import RxSwift
import RxCocoa

/// 사용 모드입니다.
enum DiaryMode {
    case create(gameInfo: KBOGame)
    case edit(diaryInfo: Diary)
}

final class DiaryEditViewModel: ViewModelType {
    private let usecase: DiaryUseCaseProtocol
    private let mode: DiaryMode
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let isPhotoChangedRelay = BehaviorRelay<Bool>(value: false)
    private let createResultRelay = PublishRelay<Result<Void, Error>>()
    private let updateResultRelay = PublishRelay<Result<Void, Error>>()
    private let deleteResultRelay = PublishRelay<Result<Void, Error>>()
    private let disposeBag = DisposeBag()
    
    struct Input {
        let recordButtonTapped: Observable<Void>
        let deleteButtonTapped: Observable<Void>
        let favoriteTeam: Observable<String>
        let seatText: Observable<String>
        let memoText: Observable<String>
        let selectedPhotoData: Observable<Data?>
        let isPhotoChanged: Observable<Void>
    }
    
    struct Output {
        let initialTeams: Driver<(
            home: String,
            away: String,
            favorite: String?
        )>
        let initialSeat: Driver<String>
        let initialMemo: Driver<String>
        let initialImageURL: Driver<String?>
        let isCreateMode: Signal<Bool>
        let isLoading: Driver<Bool>
        let createResult: Signal<Result<Void, Error>>
        let updateResult: Signal<Result<Void, Error>>
        let deleteResult: Signal<Result<Void, Error>>
    }
    
    public init(usecase: DiaryUseCaseProtocol, mode: DiaryMode) {
        self.usecase = usecase
        self.mode = mode
    }
    
    public func transform(input: Input) -> Output {
        // 모드에 따른 초기 상태를 생성합니다.
        let initialState = createInitialState()
        
        let favoriteTeam = input.favoriteTeam
            .startWith(initialState.favoriteTeam ?? initialState.homeTeam)

        let seatText = input.seatText
            .startWith(initialState.seat)

        let memoText = input.memoText
            .startWith(initialState.memo)

        let selectedPhotoData = input.selectedPhotoData
            .startWith(nil)
        
        input.isPhotoChanged
            .subscribe(onNext: { [weak self] in
                self?.isPhotoChangedRelay.accept(true)
            })
            .disposed(by: disposeBag)
        
        let currentForm = Observable.combineLatest(
            favoriteTeam,
            seatText,
            memoText,
            selectedPhotoData,
            isPhotoChangedRelay.asObservable()
        ).share(
            replay: 1,
            scope: .whileConnected
        )
        
        input.recordButtonTapped
            .throttle(
                .milliseconds(1000),
                scheduler: MainScheduler.instance
            )
            .withLatestFrom(currentForm)
            .subscribe(onNext: { [weak self] favoriteTeam, seat, memo, imageData, isImageChanged in
                guard let self = self else { return }
                // placeholder 문자열을 필터링 합니다.
                let filteredMemo = (memo != "직관 후기를 작성해보세요" && !memo.isEmpty) ? memo : ""
                switch mode {
                case .create(let game):
                    self.createDiary(
                        gameId: game.id,
                        favoriteTeam: favoriteTeam,
                        seat: seat,
                        memo: filteredMemo,
                        imageData: imageData)
                case .edit(let diary):
                    let isImageRemoved = imageData == nil && isImageChanged
                    self.updateDiary(
                        diaryId: diary.id,
                        favoriteTeam: favoriteTeam,
                        seat: seat,
                        memo: filteredMemo,
                        imageData: imageData,
                        isImageRemoved: isImageRemoved,
                    )
                }
            })
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self, case .edit(let diary) = mode else { return }
                self.deleteDiary(diaryId: diary.id)
            })
            .disposed(by: disposeBag)
        
        return Output(
            initialTeams: Driver.just((initialState.homeTeam, initialState.awayTeam, initialState.favoriteTeam)),
            initialSeat: Driver.just(initialState.seat),
            initialMemo: Driver.just(initialState.memo),
            initialImageURL: Driver.just(initialState.imageURL),
            isCreateMode: Signal.just(isCreateMode()),
            isLoading: isLoadingRelay.asDriver(),
            createResult: createResultRelay.asSignal(),
            updateResult: updateResultRelay.asSignal(),
            deleteResult: deleteResultRelay.asSignal()
        )
    }
}

extension DiaryEditViewModel {
    /// 직관 일기의 모드에 따른 초기 데이터를 설정합니다.
    private func createInitialState() -> (
        homeTeam: String,
        awayTeam: String,
        favoriteTeam: String?,
        seat: String,
        memo: String,
        imageURL: String?
    ) {
        switch mode {
        case .create(let game):
            return (
                homeTeam: game.homeTeam,
                awayTeam: game.awayTeam,
                favoriteTeam: nil,
                seat: "",
                memo: "",
                imageURL: nil
            )
        case .edit(let diary):
            return (
                homeTeam: diary.homeTeam,
                awayTeam: diary.awayTeam,
                favoriteTeam: diary.favoriteTeam,
                seat: diary.seat,
                memo: diary.memo,
                imageURL: diary.imageURL
            )
        }
    }
    
    /// 직관 일기의 편집 모드를 체크합니다.
    private func isCreateMode() -> Bool {
        switch mode {
        case .create:
            return true
        case .edit:
            return false
        }
    }
}

extension DiaryEditViewModel {
    /// 직관 일기를 생성합니다.
    private func createDiary(
        gameId: Int,
        favoriteTeam: String,
        seat: String,
        memo: String,
        imageData: Data?
    ) {
        isLoadingRelay.accept(true)
        usecase.createDiary(
            gameId: gameId,
            favoriteTeam: favoriteTeam,
            seat: seat,
            memo: memo,
            imageData: imageData
        )
        .subscribe(on: MainScheduler.instance)
        .subscribe(
            onCompleted: { [weak self] in
                self?.createResultRelay.accept(.success(()))
                self?.isLoadingRelay.accept(false)
        },
            onError: { [weak self] error in
                self?.createResultRelay.accept(.failure(error))
                self?.isLoadingRelay.accept(false)
        })
        .disposed(by: disposeBag)
    }
    
    /// 직관 일기를 수정합니다.
    private func updateDiary(
        diaryId: Int,
        favoriteTeam: String,
        seat: String,
        memo: String,
        imageData: Data?,
        isImageRemoved: Bool
    ) {
        isLoadingRelay.accept(true)
        usecase.updateDiary(
            diaryId: diaryId,
            favoriteTeam: favoriteTeam,
            seat: seat,
            memo: memo,
            imageData: imageData,
            isImageRemoved: isImageRemoved
        )
        .subscribe(onCompleted: { [weak self] in
            self?.updateResultRelay.accept(.success(()))
            self?.isLoadingRelay.accept(false)
        }, onError: { [weak self] error in
            self?.updateResultRelay.accept(.failure(error))
            self?.isLoadingRelay.accept(false)
        })
        .disposed(by: disposeBag)
    }
    
    /// 직관 일기를 삭제합니다.
    private func deleteDiary(diaryId: Int) {
        isLoadingRelay.accept(true)
        usecase.deleteDiary(diaryId: diaryId)
            .subscribe(on: MainScheduler.instance)
            .subscribe(onCompleted: { [weak self] in
                self?.isLoadingRelay.accept(false)
                self?.deleteResultRelay.accept(.success(()))
            }, onError: { [weak self] error in
                self?.isLoadingRelay.accept(false)
                self?.deleteResultRelay.accept(.failure(error))
            })
            .disposed(by: disposeBag)
    }
}
