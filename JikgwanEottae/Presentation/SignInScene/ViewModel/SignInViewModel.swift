//
//  SignInViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/5/25.
//

import Foundation

import RxSwift
import RxCocoa

final class SignInViewModel: ViewModelType {
    private let useCase: AuthUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    struct Input {
        let kakaoAccessToken: PublishRelay<String>
        let appleCredentials: PublishRelay<(String, String)>
    }
    
    struct Output {
        let loginSuccess: Signal<Void>
        let loginFailure: Signal<String>
    }
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        let loginSuccessRelay = PublishRelay<Void>()
        let loginFailureRelay = PublishRelay<String>()
        
        input.kakaoAccessToken
            .withUnretained(self)
            .subscribe(onNext: { owner, accessToken in
                owner.useCase.authenticateWithKakao(accessToken: accessToken)
                    .subscribe(onCompleted: {
                        loginSuccessRelay.accept(())
                    },onError: { error in
                        loginFailureRelay.accept(error.localizedDescription)
                    })
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
        input.appleCredentials
            .withUnretained(self)
            .subscribe(onNext: { owner, credentials in
                let (identityToken, authorizationCode) = credentials
                owner.useCase.authenticateWithApple(
                    identityToken: identityToken,
                    authorizationCode: authorizationCode
                ).subscribe(onCompleted: {
                    loginSuccessRelay.accept(())
                }, onError: { error in
                    loginFailureRelay.accept(error.localizedDescription)
                })
                .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)

        return Output(
            loginSuccess: loginSuccessRelay.asSignal(),
            loginFailure: loginFailureRelay.asSignal()
        )
    }
}
