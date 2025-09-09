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
        static let isProfileCompleted = "isProfileCompleted"
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
    
    var isProfileCompleted: Bool {
        get { UserDefaults.standard.bool(forKey: Keys.isProfileCompleted) }
        set { UserDefaults.standard.set(newValue, forKey: Keys.isProfileCompleted) }
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
    
    public func clearIsProfileCompletedKey() {
        UserDefaults.standard.removeObject(forKey: Keys.isProfileCompleted)
    }
    
}
