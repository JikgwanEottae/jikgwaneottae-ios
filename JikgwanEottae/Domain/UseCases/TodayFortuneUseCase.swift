//
//  TodayFortuneUseCase.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/3/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol TodayFortuneUseCaseProtocol {
    func fetchTodayFortune(
        dateOfBirth: String,
        timeOfBirth: String,
        gender: String,
        favoriteKBOTeam: String
    ) -> Single<Fortune>
}

final class TodayFortuneUseCase: TodayFortuneUseCaseProtocol {
    private let repository: TodayFortuneRepositoryProtocol
    
    init(repository: TodayFortuneRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchTodayFortune(
        dateOfBirth: String,
        timeOfBirth: String,
        gender: String,
        favoriteKBOTeam: String
    ) -> Single<Fortune> {
        self.repository.fetchTodayFortune(
            dateOfBirth: dateOfBirth,
            timeOfBirth: timeOfBirth,
            gender: gender,
            favoriteKBOTeam: favoriteKBOTeam
        )
    }
}
