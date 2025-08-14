//
//  DiaryEditViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/8/25.
//

import Foundation

import RxSwift
import RxCocoa

/// 직관 일기에서 사용할 모드입니다
enum DiaryMode {
    // 직관 일기 생성 모드
    case create(game: KBOGame)
    // 직관 일기 수정(삭제) 모드
    case edit(diary: Diary)
}

final class DiaryEditViewModel: ViewModelType {
    private let usecase: DiaryUseCaseProtocol
    private let mode: DiaryMode
    private let disposeBag = DisposeBag()
    
    private let isLoadingRelay = BehaviorRelay<Bool>(value: false)
    private let editResultRelay = PublishRelay<Result<Void, Error>>()
    
    struct Input {
        let createButtonTapped: Observable<Void>
//        let deleteButtonTapped: Observable<Void>
        let favoriteTeam: Observable<String>
        let seatText: Observable<String>
        let memoText: Observable<String>
        let selectedPhotoData: Observable<Data?>
    }
    
    struct Output {
        let initialHomeTeam: Driver<String>
        let initialAwayTeam: Driver<String>
        let initialFavoriteTeam: Driver<String?>
        let initialSeat: Driver<String?>
        let initialMemo: Driver<String?>
        let initialPhotoData: Driver<String?>
        let isLoading: Driver<Bool>
        let isCreateMode: Signal<Bool>
        let editResult: Signal<Result<Void, Error>>
    }
    
    public init(usecase: DiaryUseCaseProtocol, mode: DiaryMode) {
        self.usecase = usecase
        self.mode = mode
    }
    
    public func transform(input: Input) -> Output {
        // 모드에 따른 초기 상태 설정
        let initialState = createInitialState()
        
        let favoriteTeam = input.favoriteTeam

        let seatText = input.seatText

        let memoText = input.memoText
            
        let selectedPhotoData = input.selectedPhotoData
        
        let form = Observable
            .combineLatest(favoriteTeam, seatText, memoText, selectedPhotoData)
            .share(replay: 1, scope: .whileConnected)

        input.createButtonTapped
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .withLatestFrom(form)
            .subscribe(onNext: { [weak self] favoriteTeam, seat, memo, photoData in
                print("생성버튼클릭")
                guard let self = self else { return }
                let _seat = (!seat.isEmpty ? seat : nil)
                let _memo = (memo != "직관 후기를 작성해보세요" && !memo.isEmpty ? memo : nil)
                switch mode {
                case .create(let game):
                    self.createDiary(gameId: game.id, favoriteTeam: favoriteTeam, seat: _seat, memo: _memo, photoData: photoData)
                case .edit(let diary):
                    self.createDiary(gameId: diary.id, favoriteTeam: favoriteTeam, seat: _seat, memo: _memo, photoData: photoData)
                }
            })
            .disposed(by: disposeBag)
        
//        input.deleteButtonTapped
//            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
//            .subscribe(onNext: {
//                
//            })
//            .disposed(by: disposeBag)

        return Output(
            initialHomeTeam: Driver.just(initialState.homeTeam),
            initialAwayTeam: Driver.just(initialState.awayTeam),
            initialFavoriteTeam: Driver.just(initialState.favoriteTeam),
            initialSeat: Driver.just(initialState.seat),
            initialMemo: Driver.just(initialState.memo),
            initialPhotoData: Driver.just(initialState.photoData),
            isLoading: isLoadingRelay.asDriver(),
            isCreateMode: Signal.just(isCreateMode()),
            editResult: editResultRelay.asSignal()
        )
    }
}

extension DiaryEditViewModel {
    /// 직관 일기의 모드에 따른 초기 데이터를 설정합니다.
    private func createInitialState() -> (
        homeTeam: String,
        awayTeam: String,
        favoriteTeam: String?,
        seat: String?,
        memo: String?,
        photoData: String?
    ) {
        switch mode {
        case .create(game: let game):
            return (
                homeTeam: game.homeTeam,
                awayTeam: game.awayTeam,
                favoriteTeam: nil,
                seat: nil,
                memo: nil,
                photoData: nil
            )
        case .edit(diary: let diary):
            return (
                homeTeam: diary.homeTeam,
                awayTeam: diary.awayTeam,
                favoriteTeam: diary.favoriteTeam,
                seat: diary.seat,
                memo: diary.memo,
                photoData: diary.image
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
        seat: String?,
        memo: String?,
        photoData: Data?
    ) {
        isLoadingRelay.accept(true)
        usecase.createDiary(
            gameId: gameId,
            favoriteTeam: favoriteTeam,
            seat: seat,
            memo: memo,
            photoData: photoData
        )
        .subscribe(on: MainScheduler.instance)
        .subscribe(
            onCompleted: { [weak self] in
                self?.isLoadingRelay.accept(false)
                self?.editResultRelay.accept(.success(()))
        },
            onError: { [weak self] error in
                self?.isLoadingRelay.accept(false)
                self?.editResultRelay.accept(.failure(error))
        })
        .disposed(by: disposeBag)
    }
    
    /// 직관 일기를 수정합니다.
    private func updateDiary(
        diaryId: Int,
        favoriteTeam: String,
        seat: String?,
        memo: String?,
        photoData: Data?
    ) {
        isLoadingRelay.accept(true)
    }
}
