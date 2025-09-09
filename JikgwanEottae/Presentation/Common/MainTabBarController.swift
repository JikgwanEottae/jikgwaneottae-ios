//
//  MainTabBarController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

import SnapKit

// MARK: - 메인 탭 바 컨트롤러

final class MainTabBarController: UITabBarController {
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setupViewControllers()
        configureTabBarApperance()
        addTopLine(
            color: .primaryBackgroundColor,
            height: 0.5
        )
    }
    
    private func configureTabBarApperance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        // 일반 상태 탭 바
        appearance.stackedLayoutAppearance.normal.iconColor = .tertiaryTextColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .font: UIFont.pretendard(size: 10, family: .semiBold),
            .foregroundColor: UIColor.tertiaryTextColor
        ]
        // 선택 상태 탭 바
        appearance.stackedLayoutAppearance.selected.iconColor = .black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .font: UIFont.pretendard(size: 10, family: .semiBold),
            .foregroundColor: UIColor.black
        ]
        appearance.backgroundColor = .white
        appearance.shadowColor = nil
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.isTranslucent = false
    }
    
    private func setupViewControllers() {
        let home = createHome()
        let tour = createTour()
        let diary = createDiary()
        let myPage = createMyPage()
        self.viewControllers = [home, tour, diary, myPage]
    }
    
    private func addTopLine(color: UIColor, height: CGFloat) {
        let stripe = UIView()
        stripe.backgroundColor = color
        tabBar.addSubview(stripe)
        stripe.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalTo(tabBar)
            make.height
                .equalTo(height)
        }
    }
}

extension MainTabBarController {
    /// 홈 화면을 생성합니다.
    private func createHome() -> UINavigationController {
        let kboGameRepository = KBOGameRepository(networkManager: KBOGameNetworkManager.shared)
        let diaryRepository = DiaryRepository(networkManger: DiaryNetworkManager.shared)
        let kboGameUseCase = KBOGameUseCase(repository: kboGameRepository)
        let diaryUseCase = DiaryUseCase(repository: diaryRepository)
        let viewModel = HomeViewModel(diaryUseCase: diaryUseCase, kboGameUseCase: kboGameUseCase)
        let homeViewController = HomeViewController(viewModel: viewModel)
        let homeNavigationController = UINavigationController(rootViewController: homeViewController)
        homeNavigationController.configureBarAppearnace()
        homeNavigationController.tabBarItem = UITabBarItem(
            title: "홈",
            image: .home,
            tag: 0
        )
        return homeNavigationController
    }
    
    /// 관광 화면을 생성합니다.
    private func createTour() -> UINavigationController {
        let tourHomeViewController = TourHomeViewController()
        let tourNavigationController = UINavigationController(rootViewController: tourHomeViewController)
        tourNavigationController.configureBarAppearnace()
        tourNavigationController.tabBarItem = UITabBarItem(
            title: "지도",
            image: .markerIcon,
            tag: 1
        )
        return tourNavigationController
    }
    
    /// 직관일기 화면을 생성합니다.
    private func createDiary() -> UINavigationController {
        let diaryRepository = DiaryRepository(networkManger: DiaryNetworkManager.shared)
        let diartUseCase = DiaryUseCase(repository: diaryRepository)
        let diaryViewModel = DiaryViewModel(useCase: diartUseCase)
        let diaryViewController = DiaryViewController(viewModel: diaryViewModel)
        let diaryNavigationController = UINavigationController(rootViewController: diaryViewController)
        diaryNavigationController.configureBarAppearnace()
        diaryNavigationController.tabBarItem = UITabBarItem(
            title: "기록",
            image: .ticket,
            tag: 2
        )
        return diaryNavigationController
    }
    
    /// 마이 페이지 화면을 생성합니다.
    private func createMyPage() -> UINavigationController {
        let authRepository = AuthRepository(networkManaer: AuthNetworkManager.shared)
        let authUseCase = AuthUseCase(repository: authRepository)
        let myPageViewModel = MyPageViewModel(useCase: authUseCase)
        let myPageViewController = MyPageViewController(viewModel: myPageViewModel)
        let myPageNavigationController = UINavigationController(rootViewController: myPageViewController)
        myPageNavigationController.configureBarAppearnace()
        myPageNavigationController.tabBarItem = UITabBarItem(
            title: "마이",
            image: .userIcon,
            tag: 1
        )
        return myPageNavigationController
    }
}

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        HapticFeedbackManager.shared.light()
    }
}
