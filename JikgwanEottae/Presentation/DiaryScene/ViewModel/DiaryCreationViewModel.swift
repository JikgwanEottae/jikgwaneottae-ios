//
//  DiaryCreateViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/12/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DiaryCreationViewModel: ViewModelType {
    private let useCase: DiaryUseCaseProtocol
    private let selectedGame: KBOGame
    private let disposeBag = DisposeBag()
    
    struct Input {
        let selectedPhotoData: PublishRelay<Data?>
        let supportTeam: Observable<String>
        let seat: Observable<String>
        let memo: Observable<String>
        let isPhotoChanged: BehaviorRelay<Bool>
        let createButtonTapped: Observable<Void>
    }
    
    struct Output {
        let supportTeamPickerItems: Driver<[String]>
        let title: Driver<String>
        let formError: Signal<Void>
        let isLoading: Driver<Bool>
        let creationSuccess: Signal<Void>
        let creationFailure: Signal<Void>
    }
    
    init(useCase: DiaryUseCaseProtocol, selectedGame: KBOGame) {
        self.useCase = useCase
        self.selectedGame = selectedGame
    }
    
    public func transform(input: Input) -> Output {
        let formErrorRelay = PublishRelay<Void>()
        let isLoadingDriver = BehaviorRelay<Bool>(value: false)
        let creationSuccessRelay = PublishRelay<Void>()
        let creationFailureRelay = PublishRelay<Void>()
        
        let inputCombined = Observable.combineLatest(
            input.selectedPhotoData.startWith(nil),
            input.supportTeam,
            input.seat.startWith(""),
            input.memo.startWith("")
        )
        
        input.createButtonTapped
            .withLatestFrom(inputCombined)
            .filter{ _, supportTeam, _, _ in
                if supportTeam.isEmpty {
                    formErrorRelay.accept(())
                    return false
                }
                return true
            }
            .withUnretained(self)
            .flatMap{ owner, values -> Observable<Void> in
                let (photoData, supportTeam, seat, memo) = values
                let gameID = owner.selectedGame.id
                isLoadingDriver.accept(true)
                return owner.useCase.createDiary(gameID: gameID, favoriteTeam: supportTeam, seat: seat, memo: memo, imageData: photoData)
                    .andThen(Observable.just(()))
                    .catch { error in
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: {
                isLoadingDriver.accept(false)
                creationSuccessRelay.accept(())
            }, onError: { error in
                isLoadingDriver.accept(false)
                creationFailureRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            supportTeamPickerItems: Driver.just([selectedGame.homeTeam, selectedGame.awayTeam]),
            title: Driver.just("\(selectedGame.homeTeam) vs \(selectedGame.awayTeam)"),
            formError: formErrorRelay.asSignal(),
            isLoading: isLoadingDriver.asDriver(),
            creationSuccess: creationSuccessRelay.asSignal(),
            creationFailure: creationFailureRelay.asSignal()
        )
    }
}
