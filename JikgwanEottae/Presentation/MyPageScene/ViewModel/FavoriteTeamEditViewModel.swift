//
//  FavoriteTeamEditViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/27/25.
//

import Foundation

import RxSwift
import RxCocoa

final class FavoriteTeamEditViewModel: ViewModelType {
    private let useCase: AuthUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    struct Input {
        let favoriteTeam: Observable<String>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let teams: Driver<[String]>
        let isLoading: Driver<Bool>
        let editSuccess: Signal<Void>
        let editFailure: Signal<Void>
    }
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension FavoriteTeamEditViewModel {
    public func transform(input: Input) -> Output {
        let allCases = KBOTeam.allCases.map { $0.rawValue }
        let teams = BehaviorRelay<[String]>(value: allCases)
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        let success = PublishRelay<Void>()
        let failure = PublishRelay<Void>()
        
        input.completeButtonTapped
            .withLatestFrom(input.favoriteTeam)
            .flatMapLatest { [weak self] favoriteTeam -> Observable<Void> in
                guard let self = self else { return .empty() }
                isLoadingRelay.accept(true)
                let teamValue: String
                if favoriteTeam.trimmingCharacters(in: .whitespaces).isEmpty {
                    teamValue = ""
                } else if let team = KBOTeam(rawValue: favoriteTeam) {
                    teamValue = "\(team)"
                } else {
                    isLoadingRelay.accept(false)
                    return .empty()
                }
                return useCase.updateFavoriteTeam(team: teamValue)
                    .andThen(Observable.just(()))
                    .asObservable()
            }
            .subscribe(onNext: { _ in
                success.accept(())
                isLoadingRelay.accept(false)
            }, onError: { _ in
                failure.accept(())
                isLoadingRelay.accept(false)
            })
            .disposed(by: disposeBag)
        
        
        return Output(
            teams: teams.asDriver(),
            isLoading: isLoadingRelay.asDriver(),
            editSuccess: success.asSignal(),
            editFailure: failure.asSignal()
        )
    }
}
