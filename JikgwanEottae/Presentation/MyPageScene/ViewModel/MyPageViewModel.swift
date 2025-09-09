//
//  MyPageViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/9/25.
//

import Foundation

import RxSwift
import RxCocoa

final class MyPageViewModel: ViewModelType {
    private let useCase: AuthUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    struct Input {
        let signOutButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let signOutSuccess: Signal<Void>
        let signOutFailure: Signal<Void>
    }
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
    
    
    public func transform(input: Input) -> Output {
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        let signOutSuccessRelay = PublishRelay<Void>()
        let signOutFailureRelay = PublishRelay<Void>()
    
        input.signOutButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Void> in
                isLoadingRelay.accept(true)
                return owner.useCase.signOut()
                    .andThen(Observable.just(()))
            }
            .subscribe(onNext: {
                isLoadingRelay.accept(false)
                signOutSuccessRelay.accept(())
            }, onError: { error in
                isLoadingRelay.accept(false)
                signOutFailureRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            isLoading: isLoadingRelay.asDriver(),
            signOutSuccess: signOutSuccessRelay.asSignal(),
            signOutFailure: signOutFailureRelay.asSignal()
        )
    }
}
