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
        let profileImageData: Observable<(Bool, Data?)>
    }
    
    struct Output {
        let isLoading: Driver<Bool>
        let signOutSuccess: Signal<Void>
        let signOutFailure: Signal<Void>
        let updateProfileImageSuccess: Signal<Void>
        let updateProfileImagefailure: Signal<Void>
    }
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        let signOutSuccessRelay = PublishRelay<Void>()
        let signOutFailureRelay = PublishRelay<Void>()
        let updateProfileImageSuccessRelay = PublishRelay<Void>()
        let updateProfileImageErrorRelay = PublishRelay<Void>()
    
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
        
        input.profileImageData
            .withUnretained(self)
            .flatMap { owner, tuple -> Observable<Void> in
                let (isImageRemoved, imageData) = tuple
                return owner.useCase.updateProfileImage(
                    isImageRemoved: isImageRemoved,
                    imageData: imageData
                )
                .andThen(Observable.just(()))
            }
            .subscribe(onNext: {
                updateProfileImageSuccessRelay.accept(())
            }, onError: { error in
                updateProfileImageErrorRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            isLoading: isLoadingRelay.asDriver(),
            signOutSuccess: signOutSuccessRelay.asSignal(),
            signOutFailure: signOutFailureRelay.asSignal(),
            updateProfileImageSuccess: updateProfileImageSuccessRelay.asSignal(),
            updateProfileImagefailure: updateProfileImageErrorRelay.asSignal()
        )
    }
}
