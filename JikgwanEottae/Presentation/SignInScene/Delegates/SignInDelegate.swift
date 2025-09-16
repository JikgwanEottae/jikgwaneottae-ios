//
//  SignInDelegate.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/16/25.
//

import Foundation

/// 로그인 델리게이트 프로토콜입니다.
protocol SignInDelegate: AnyObject {
    func signInDidComplete()
}

/// 로그아웃 델리게이트 프로토콜입니다.
protocol SignOutDelegate: AnyObject {
    func signOutDidComplete()
}
