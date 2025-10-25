//
//  TodayFortuneRepository.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/3/25.
//

import Foundation

import RxSwift

final class TodayFortuneRepository: TodayFortuneRepositoryProtocol {
    private let networkManager:  TodayFortuneNetworkManager
    
    init(networkManager: TodayFortuneNetworkManager) {
        self.networkManager = networkManager
    }
    
    public func fetchTodayFortune(
        date: String,
        time: Int?,
        gender: String,
        favoriteTeam: String
    ) -> Single<Fortune> {
        let todayFortuneRequestDTO = TodayFortuneRequestDTO(
            date: date,
            time: time,
            gender: gender,
            favoriteTeam: favoriteTeam
        )
        return self.networkManager.fetchTodayFortune(params: todayFortuneRequestDTO)
    }
}
