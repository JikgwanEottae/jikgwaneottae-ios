//
//  UIFont+.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

extension UIFont {
    // 프리텐다드 폰트
    enum Pretendard: String {
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
        case semiBold = "Pretendard-SemiBold"
        case bold = "Pretendard-Bold"
    }
    // KBO 폰트
    enum KBO: String {
        case medium = "KBO-Dia-Gothic-Medium"
        case bold = "KBO-Dia-Gothic-Bold"
    }
    // GmarketSans 폰트
    enum GmarketSans: String {
        case light = "GmarketSansLight"
        case medium = "GmarketSansMedium"
        case bold = "GmarketSansBold"
    }
    static func pretendard(size: CGFloat, family: Pretendard) -> UIFont {
        return UIFont(name: family.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func kbo(size: CGFloat, family: KBO) -> UIFont {
        return UIFont(name: family.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    static func gMarketSans(size: CGFloat, family: GmarketSans) -> UIFont {
        return UIFont(name: family.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
