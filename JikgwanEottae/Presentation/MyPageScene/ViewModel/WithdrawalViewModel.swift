//
//  WithdrawalViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/10/25.
//

import Foundation

import RxSwift
import RxCocoa

final class WithdrawalViewModel: ViewModelType {
    private let useCase: AuthUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    struct Input {
        let withdrawButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let withdrawalSuccess: Signal<Void>
        let withdrawalFailure: Signal<Void>
    }
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        let withdrawalSuccessRelay = PublishRelay<Void>()
        let withdrawalFailureRelay = PublishRelay<Void>()
        
        input.withdrawButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Void> in
                isLoadingRelay.accept(true)
                return owner.useCase.withdrawAccount()
                    .andThen(Observable.just(()))
            }
            .subscribe(onNext: {
                isLoadingRelay.accept(false)
                withdrawalSuccessRelay.accept(())
            }, onError: { error in
                isLoadingRelay.accept(false)
                withdrawalFailureRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            isLoading: isLoadingRelay.asDriver(),
            withdrawalSuccess: withdrawalSuccessRelay.asSignal(),
            withdrawalFailure: withdrawalFailureRelay.asSignal()
        )
    }
    
    
}
