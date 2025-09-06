//
//  KeyChainmanager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/4/25.
//

// MARK: - 토큰 관리를 위한 키체인 매니저

import KeychainAccess

final class KeychainManager {
    static let shared = KeychainManager()
    private let keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    
    private init() { }
    
    func saveAccessToken(_ accessToken: String) throws {
        try keychain.set(accessToken, key: "accessToken")
    }
    
    func saveRefreshToken(_ refreshToken: String) throws {
        try keychain.set(refreshToken, key: "refreshToken")
    }
    
    func readAccessToken() -> String? {
        return try? keychain.get("accessToken")
    }
    
    func readRefreshToken() -> String? {
        return try? keychain.get("refreshToken")
    }
    
    func deleteTokens() throws {
        try keychain.remove("accessToken")
        try keychain.remove("refreshToken")
    }
    
}
