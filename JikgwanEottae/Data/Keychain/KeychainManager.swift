//
//  KeyChainmanager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/4/25.
//

// MARK: - 토큰 관리를 위한 키체인 매니저

import KeychainAccess

final class KeychainManager {
    // 싱글톤
    static let shared = KeychainManager()
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    private init() { }
    
    // AccessToken 저장
    func saveAccessToken(_ accessToken: String) throws {
        try keychain.set(accessToken, key: "accessToken")
    }
    
    // RefreshToken 저장
    func saveRefreshToken(_ refreshToken: String) throws {
        try keychain.set(refreshToken, key: "refreshToken")
    }
    
    // AccessToken 읽기
    func readAccessToken() -> String? {
        return try? keychain.get("accessToken")
    }
    
    // RefreshToken 읽기
    func readRefreshToken() -> String? {
        return try? keychain.get("refreshToken")
    }
    
    // AccessToken 및 RefreshToken 제거
    func deleteTokens() throws {
        try keychain.remove("accessToken")
        try keychain.remove("refreshToken")
    }
    
}
