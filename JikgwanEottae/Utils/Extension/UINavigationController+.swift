//
//  UINavigationController+.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

extension UINavigationController {
    /// 네비게이션 컨트롤러 바 커스텀
    public func configureBarAppearnace() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [
            .font: UIFont.pretendard(size: 18, family: .semiBold),
            .foregroundColor: UIColor.Text.secondaryColor
        ]
        navigationBar.tintColor = UIColor.Text.primaryColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
    }
    
    /// 투명 네비게이션 컨트롤러 바 커스텀
    public func configureTransparentBarAppearnace() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        appearance.backgroundEffect = blurEffect
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [
            .font: UIFont.pretendard(size: 18, family: .semiBold),
            .foregroundColor: UIColor.Text.secondaryColor
        ]
        navigationBar.tintColor = UIColor.Text.secondaryColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
    }
}

