//
//  KBOGameRepository.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/7/25.
//

import Foundation

import RxSwift
import RxCocoa

// MARK: - KBO 경기 정보 리포지토리

final class KBOGameRepository {
    private let networkManager: KBOGameNetworkManager
    
    init(networkManager: KBOGameNetworkManager) {
        self.networkManager = networkManager
    }
    
}
