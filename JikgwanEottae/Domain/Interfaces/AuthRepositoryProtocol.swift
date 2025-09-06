//
//  AuthRepositoryProtocol.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/5/25.
//

import Foundation

import RxSwift

// MARK: - 사용자의 계정 인증 프로토콜입니다.

protocol AuthRepositoryProtocol {
    /// 카카오 계정으로 로그인합니다.
    func authenticateWithKakao(accessToken: String) -> Completable
    
    /// 애플 계정으로 로그인합니다.
    func authenticateWithApple(
        identityToken: String,
        authorizationCode: String
    ) -> Completable
}
