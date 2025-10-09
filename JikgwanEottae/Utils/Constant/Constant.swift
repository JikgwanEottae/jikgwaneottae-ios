//
//  Layout.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import Foundation

// MARK: - 상수를 관리합니다.

enum Constants {
    static let cornerRadius = CGFloat(24)
    static let tableViewRowHeight = CGFloat(140)
    static let buttonHeight = CGFloat(57)
    static let buttonCornerRadius = CGFloat(12)
    
    enum Layout {
        static let inset = CGFloat(12)
        static let offset = CGFloat(12)
        static let cornerRadius = CGFloat(24)
    }
    
    enum EdgeInset {
        static let top = CGFloat(10)
        static let left = CGFloat(12)
        static let right = CGFloat(12)
        static let bottom = CGFloat(10)
    }
    
    enum TabBarTags {
        static let home = 1000
        static let tour = 1001
        static let diary = 1002
        static let myPage = 1003
    }
}
