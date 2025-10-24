//
//  SplahViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/9/25.
//

import Foundation

import RxSwift
import RxCocoa

final class SplahViewModel: ViewModelType {
    private let useCase: AuthUseCase
    private let disposeBag = DisposeBag()
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let navigateToMain: Observable<Void>
    }
    
    init(useCase: AuthUseCase) {
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        let navigateToMainRelay = PublishRelay<Void>()
        
        input.viewDidLoad
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // 리프레쉬 토큰을 가지고 있는지 체크합니다.
                guard let refreshToken = KeychainManager.shared.readRefreshToken() else {
                    // 게스트입니다.
                    print("게스트 입니다.")
                    navigateToMainRelay.accept(())
                    return
                }
                owner.useCase.validateRefreshToken(refreshToken)
                    .subscribe(onCompleted: {
                        // 회원입니다.
                        print("토큰 인증: 회원 입니다.")
                        navigateToMainRelay.accept(())
                    }, onError: { error in
                        // 게스트입니다.
                        print("토큰 만료: 게스트 입니다.")
                        navigateToMainRelay.accept(())
                    })
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
        return Output(
            navigateToMain: navigateToMainRelay.asObservable()
        )
    }
    
}
