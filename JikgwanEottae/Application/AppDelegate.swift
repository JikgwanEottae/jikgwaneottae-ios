//
//  AppDelegate.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import CoreData
import UIKit

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoMapsSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupKakaoSDK()
        handleFirstLaunch()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "JikgwanEottae")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    /// 카카오 SDK를 초기화합니다.
    private func setupKakaoSDK() {
        guard let kakaoAppKey = Bundle.main.infoDictionary?["KakaoAppKey"] as? String else {
            fatalError("KakaoAppKey not found in Info.plist")
        }
        SDKInitializer.InitSDK(appKey: kakaoAppKey)
        KakaoSDK.initSDK(appKey: kakaoAppKey)
    }
    
    /// 앱을 처음 시작여부에 따라 토큰과 UserDefaults를 설정합니다.
    private func handleFirstLaunch() {
        if !UserDefaultsManager.shared.hasLaunchedBefore {
            try? KeychainManager.shared.deleteAllTokens()
            UserDefaultsManager.shared.clearAllKeys()
        }
        UserDefaultsManager.shared.hasLaunchedBefore = true
    }
}
