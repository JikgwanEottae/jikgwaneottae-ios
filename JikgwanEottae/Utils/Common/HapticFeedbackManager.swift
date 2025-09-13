//
//  HapticFeedbackManager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/29/25.
//

import UIKit

final class HapticFeedbackManager {
    
    static let shared = HapticFeedbackManager()
    
    private let lightImpact = UIImpactFeedbackGenerator(style: .light)
    private let mediumImpact = UIImpactFeedbackGenerator(style: .medium)
    private let heavyImpact = UIImpactFeedbackGenerator(style: .heavy)
    private let notificationFeedback = UINotificationFeedbackGenerator()
    
    private init() {
        prepareAllFeedbacks()
    }
    
    private func prepareAllFeedbacks() {
        lightImpact.prepare()
        mediumImpact.prepare()
        heavyImpact.prepare()
    }
    
    public func light() {
        lightImpact.impactOccurred()
        lightImpact.prepare()
    }
    
    public func medium() {
        mediumImpact.impactOccurred()
        mediumImpact.prepare()
    }
    
    public func heavy() {
        heavyImpact.impactOccurred()
        heavyImpact.prepare()
    }
    
    public func success() {
        notificationFeedback.notificationOccurred(.success)
    }
    
    public func warning() {
        notificationFeedback.notificationOccurred(.warning)
    }
    
    public func error() {
        notificationFeedback.notificationOccurred(.error)
    }
}
