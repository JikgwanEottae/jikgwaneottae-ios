//
//  UserDefaultsManager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/8/25.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    
    private init () { }
    
    private enum Keys {
        static let nickname = "nickname"
        static let profileImageURL = "profileImageURL"
        static let favoriteTeam = "favoriteTeam"
        static let hasLaunchedBefore = "hasLaunchedBefore"
    }
    
    var nickname: String? {
        get { UserDefaults.standard.string(forKey: Keys.nickname) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.nickname) }
    }
    
    var profileImageURL: String? {
        get { UserDefaults.standard.string(forKey: Keys.profileImageURL) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.profileImageURL) }
    }
    
    var favoriteTeam: String? {
        get { UserDefaults.standard.string(forKey: Keys.favoriteTeam) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.favoriteTeam) }
    }
    
    var hasLaunchedBefore: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.hasLaunchedBefore) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.hasLaunchedBefore) }
    }
    
    public func clearNicknameKey() {
        UserDefaults.standard.removeObject(forKey: Keys.nickname)
    }
    
    public func clearProfileImageURLKey() {
        UserDefaults.standard.removeObject(forKey: Keys.profileImageURL)
    }
    
    public func clearFavoriteTeamKey() {
        UserDefaults.standard.removeObject(forKey: Keys.favoriteTeam)
    }
    
    public func clearAllKeys() {
        UserDefaults.standard.removeObject(forKey: Keys.nickname)
        UserDefaults.standard.removeObject(forKey: Keys.profileImageURL)
        UserDefaults.standard.removeObject(forKey: Keys.favoriteTeam)
    }
}
