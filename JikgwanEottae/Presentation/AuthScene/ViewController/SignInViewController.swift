//
//  SignInViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/4/25.
//

import AuthenticationServices
import UIKit

import RxSwift
import RxCocoa
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

final class SignInViewController: UIViewController {
    private let signInView = SignInView()
    private let viewModel: SignInViewModel
    private let disposeBag = DisposeBag()
    private let kakaoLoginResultRelay = PublishRelay<String>()
    private let appleLoginResultRelay = PublishRelay<(String, String)>()
    
    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtonActions()
        bindViewModel()
    }
    
    /// 각 버튼의 addTarget을 설정합니다.
    private func setupButtonActions() {
        self.signInView.appleSignInButton.addTarget(
            self,
            action: #selector(handleAppleSignInButtonTap),
            for: .touchUpInside
        )
        self.signInView.kakaoSignInButton.addTarget(
            self,
            action: #selector(handleKakaoSignInButtonTap),
            for: .touchUpInside
        )
    }
    
    /// 뷰 모델과 바인딩합니다.
    private func bindViewModel() {
        let input = SignInViewModel.Input(
            kakaoAccessToken: kakaoLoginResultRelay,
            appleCredentials: appleLoginResultRelay
        )
        
        let output = viewModel.transform(input: input)
        
        output.loginSuccess
            .withUnretained(self)
            .emit(onNext: { owner, _ in
                let authRepository = AuthRepository(
                    networkManaer: AuthNetworkManager.shared,
                    keychainManager: KeychainManager.shared
                )
                let authUseCase = AuthUseCase(repository: authRepository)
                let nicknameViewModel = NicknameEditViewModel(useCase: authUseCase)
                let nicknameEditViewController = NicknameEditViewController(viewModel: nicknameViewModel)
                nicknameEditViewController.modalPresentationStyle = .fullScreen
                owner.present(nicknameEditViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        output.loginFailure
            .withUnretained(self)
            .emit(onNext: { error in
                print("에러: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

extension SignInViewController {
    /// "애플로 로그인" 버튼 클릭 이벤트입니다.
    @objc private func handleAppleSignInButtonTap() {
        performAppleSignIn()
    }
    
    /// "카카오로 로그인" 버튼 클릭 이벤트입니다.
    @objc private func handleKakaoSignInButtonTap() {
        performKakaoSignIn()
    }
}

extension SignInViewController {
    /// 카카오 로그인을 수행합니다.
    private func performKakaoSignIn() {
        UserApi.isKakaoTalkLoginAvailable()
        ? signInWithKakaoTalkApp()
        : signInWithKakaoWebAccount()
    }
    
    /// 카카오톡 앱으로 로그인합니다.
    private func signInWithKakaoTalkApp() {
        UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
            self?.handleKakaoLoginResponse(oauthToken: oauthToken, error: error)
        }
    }
    
    /// 카카오 웹 계정으로 로그인합니다.
    private func signInWithKakaoWebAccount() {
        UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
            self?.handleKakaoLoginResponse(oauthToken: oauthToken, error: error)
        }
    }
    
    /// 카카오 로그인 응답을 처리합니다.
    private func handleKakaoLoginResponse(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            print(error)
        } else if let accessToken = oauthToken?.accessToken {
            kakaoLoginResultRelay.accept(accessToken)
        }
    }
    
    /// 애플 로그인을 수행합니다.
    private func performAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    /// 애플 credential을 처리하여 토큰들을 추출합니다.
    private func processAppleCredential(_ credential: ASAuthorizationAppleIDCredential) -> (String, String)? {
        guard let identityTokenData = credential.identityToken,
              let authorizationCodeData = credential.authorizationCode,
              let identityToken = String(data: identityTokenData, encoding: .utf8),
              let authorizationCode = String(data: authorizationCodeData, encoding: .utf8)
        else { return nil }
        return (identityToken, authorizationCode)
    }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
    /// 애플 로그인 실패 처리입니다.
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: any Error
    ) {
        print("로그인 실패", error.localizedDescription)
    }
    
    /// 애플 로그인 성공 처리입니다.
    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let processedCredentials = processAppleCredential(appleIDCredential)
        else { return }
        appleLoginResultRelay.accept(processedCredentials)
    }
}

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window ?? UIWindow()
    }
}
