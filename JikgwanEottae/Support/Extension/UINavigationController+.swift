//
//  UINavigationController+.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

extension UINavigationController {
    // MARK: - 네비게이션 컨트롤러 바 커스텀
    public func configureBarAppearnace() {
        let appearance = UINavigationBarAppearance()
        // 네비게이션 바의 그림자를 제거 및 단일 배경색 설정
        appearance.configureWithTransparentBackground()
        // 네비게이션 바의 전체 배경 색 설정
        appearance.backgroundColor = .white
        // 네비게이션 바의 타이틀 폰트 및 색상 설정
        appearance.titleTextAttributes = [
            .font: UIFont.gMarketSans(size: 17, family: .medium),
            .foregroundColor: UIColor.primaryTextColor
        ]
        // 네비게이션 바의 틴트 컬러(내부 요소들 색상)
        navigationBar.tintColor = .black
        // 커스텀 appearance 적용
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
}
