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
        dateOfBirth: String,
        timeOfBirth: String,
        gender: String,
        favoriteKBOTeam: String
    ) -> Single<Fortune> {
        let _time = timeOfBirth.isEmpty ? nil : Int(timeOfBirth)
        let _gender = (gender == "남자") ? "M" : "F"
        let todayFortuneRequestDTO = TodayFortuneRequestDTO(
            birth_date: dateOfBirth,
            time: _time,
            gender: _gender,
            team_name: favoriteKBOTeam
        )
        return self.networkManager.fetchTodayFortune(params: todayFortuneRequestDTO)
    }
}
