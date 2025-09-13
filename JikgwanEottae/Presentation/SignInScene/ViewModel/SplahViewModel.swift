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
        let navigateToSignIn: Observable<Void>
        let navigateToMain: Observable<Void>
    }
    
    init(useCase: AuthUseCase) {
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        let navigateToSignIn = PublishRelay<Void>()
        let navigateToMain = PublishRelay<Void>()
        
        input.viewDidLoad
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                // 리프레쉬 토큰을 가지고 있는지 체크합니다.
                // 프로필을 생성한 경험이 있는지 체크합니다.
                guard let refreshToken = KeychainManager.shared.readRefreshToken(),
                      UserDefaultsManager.shared.isProfileCompleted else {
                    // 리프레쉬 토큰이 없거나, 프로필을 생성한 경험이 없습니다.
                    // 따라서, 로그인 화면으로 전환하는 이벤트를 전달합니다.
                    navigateToSignIn.accept(())
                    return
                }
                owner.useCase.validateRefreshToken(refreshToken)
                    .subscribe(onCompleted: {
                        navigateToMain.accept(())
                    }, onError: { error in
                        navigateToSignIn.accept(())
                    })
                    .disposed(by: owner.disposeBag)
            })
            .disposed(by: disposeBag)
        
        return Output(
            navigateToSignIn: navigateToSignIn.asObservable(),
            navigateToMain: navigateToMain.asObservable()
        )
    }
    
}
