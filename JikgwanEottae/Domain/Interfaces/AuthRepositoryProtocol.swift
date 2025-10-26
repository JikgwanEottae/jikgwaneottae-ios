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
    /// 카카오 계정으로 로그인 인증합니다.
    func authenticateWithKakao(
        accessToken: String
    ) -> Completable
    
    /// 애플 계정으로 로그인 인증합니다.
    func authenticateWithApple(
        identityToken: String,
        authorizationCode: String
    ) -> Completable
    
    /// 프로필 닉네임을 설정합니다.
    func setProfileNickname(
        _ nickname: String
    ) -> Completable
    
    /// 프로필 이미지를 업데이트합니다.
    func updateProfileImage(
        isImageRemoved: Bool,
        imageData: Data?
    ) -> Completable
    
    /// 응웜팀을 설정합니다.
    func updateFavoriteTeam(
        team: String
    ) -> Completable
    
    /// 리프레쉬 토큰 검증을 수행합니다.
    func validateRefreshToken(
        _ refreshToken: String
    ) -> Completable
    
    /// 로그아웃을 수행합니다.
    func signOut() -> Completable
    
    /// 가입된 계정을 탈퇴합니다.
    func withdrawAccount() -> Completable
    
}
