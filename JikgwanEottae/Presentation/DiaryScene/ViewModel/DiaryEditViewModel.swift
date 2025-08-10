//
//  DiaryEditViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/8/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DiaryEditViewModel: ViewModelType {
    private let usecase: DiaryUseCaseProtocol
    public let selectedKBOGame: KBOGame
    private let isLoadingRelay  = BehaviorRelay<Bool>(value: false)
    private let disposeBag = DisposeBag()
    
    struct Input {
        let createButtonTapped: Observable<Void>
        let favoriteTeam: Observable<String>
        let seatText: Observable<String?>
        let memoText: Observable<String?>
        let selectedPhotoData: Observable<Data?>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
    }
    
    public init(usecase: DiaryUseCaseProtocol, selectedKBOGame: KBOGame) {
        self.usecase = usecase
        self.selectedKBOGame = selectedKBOGame
    }
    
    public func transform(input: Input) -> Output {
        let favoriteTeam = input.favoriteTeam
            .startWith(selectedKBOGame.homeTeam)
            .distinctUntilChanged()

        let seatText = input.seatText
            .startWith(nil)
            .distinctUntilChanged()

        let memoText = input.memoText
            .startWith(nil)
            .distinctUntilChanged()

        let selectedPhotoData = input.selectedPhotoData
            .startWith(nil)

        let form = Observable
            .combineLatest(favoriteTeam, seatText, memoText, selectedPhotoData)
            .share(replay: 1, scope: .whileConnected)

        input.createButtonTapped
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .withLatestFrom(form)
            .subscribe(onNext: { [weak self] favoriteTeam, seat, memo, photoData in
                guard let self = self else { return }
                let gameId = self.selectedKBOGame.id
                let _memo = (memo != "직관 후기를 작성해보세요" ? memo : nil)
                self.createDiary(gameId: gameId, favoriteTeam: favoriteTeam, seat: seat, memo: _memo, photoData: photoData)
            })
            .disposed(by: disposeBag)

        return Output(
            isLoading: isLoadingRelay.asDriver()
        )
    }
}

extension DiaryEditViewModel {
    public func createDiary(
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
        },
            onError: { [weak self] error in
                print(error)
                self?.isLoadingRelay.accept(false)
        })
        .disposed(by: disposeBag)
    }
}
