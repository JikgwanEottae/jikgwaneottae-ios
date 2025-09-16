//
//  SceneDelegate.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        setupWindow(with: windowScene)
        setupInitialViewController()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        handleKakaoLoginURL(from: URLContexts)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    /// 윈도우를 설정합니다.
    func setupWindow(with windowScene: UIWindowScene) {
        window = UIWindow(windowScene: windowScene)
        window?.overrideUserInterfaceStyle = .light
        window?.makeKeyAndVisible()
    }
    
    /// 초기 뷰 컨트롤러를 설정합니다.
    func setupInitialViewController() {
        let splashViewController = createSplashViewController()
        window?.rootViewController = splashViewController
    }
    
    /// 스플래시 뷰 컨트롤러를 생성합니다.
    func createSplashViewController() -> SplashViewController {
        let authRepository = AuthRepository(networkManaer: AuthNetworkManager.shared)
        let authUseCase = AuthUseCase(repository: authRepository)
        let splashViewModel = SplahViewModel(useCase: authUseCase)
        return SplashViewController(viewModel: splashViewModel)
    }
    
    ///카카오 로그인 URL을 처리합니다.
    func handleKakaoLoginURL(from URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
    
    /// 현재 윈도우의 루트 뷰 컨트롤러를 변경합니다.
    func changeRootViewController(to viewController: UIViewController, animated: Bool = true) {
        guard let window = window else { return }
        window.rootViewController = viewController
        if animated {
            UIView.transition(
                with: window,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: nil,
                completion: nil
            )
        }
    }
}
