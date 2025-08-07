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
        // 홈
        let homeVC = HomeViewController()
        let homeNVC = UINavigationController(rootViewController: homeVC)
        homeNVC.configureBarAppearnace()
        homeNVC.tabBarItem = UITabBarItem(
            title: "홈",
            image: .home,
            tag: 0
        )
        
        // 직관 기록
        let diaryRepository = DiaryRepository(networkManger: DiaryNetworkManager.shared)
        let diartUseCase = DiaryUseCase(repository: diaryRepository)
        let diaryViewModel = DiaryViewModel(usecase: diartUseCase)
        let diaryViewController = DiaryViewController(viewModel: diaryViewModel)
        let diaryNavigationController = UINavigationController(rootViewController: diaryViewController)
        diaryNavigationController.configureBarAppearnace()
        diaryNavigationController.tabBarItem = UITabBarItem(
            title: "기록",
            image: .ticket,
            tag: 1
        )
        self.viewControllers = [
            homeNVC,
            diaryNavigationController
        ]
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
