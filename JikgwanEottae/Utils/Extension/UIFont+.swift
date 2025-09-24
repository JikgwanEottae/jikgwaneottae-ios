//
//  UIFont+.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

extension UIFont {
    // 프리텐다드
    enum Pretendard: String {
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
        case semiBold = "Pretendard-SemiBold"
        case bold = "Pretendard-Bold"
    }
    
    // GmarketSans
    enum GmarketSans: String {
        case light = "GmarketSansLight"
        case medium = "GmarketSansMedium"
        case bold = "GmarketSansBold"
    }
    
    // 페이퍼로지
    enum Paperlogy: String {
        case light = "PaperLogy-3Light"
        case regular = "PaperLogy-4Regular"
        case medium = "PaperLogy-5Medium"
        case semiBold = "PaperLogy-6SemiBold"
        case bold = "PaperLogy-7Bold"
    }
    
    static func pretendard(size: CGFloat, family: Pretendard) -> UIFont {
        return UIFont(name: family.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func gMarketSans(size: CGFloat, family: GmarketSans) -> UIFont {
        return UIFont(name: family.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static func paperlogy(size: CGFloat, family: Paperlogy) -> UIFont {
        return UIFont(name: family.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

}
