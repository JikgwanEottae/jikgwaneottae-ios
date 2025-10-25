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
        date: String,
        time: Int?,
        gender: String,
        favoriteTeam: String
    ) -> Single<Fortune>
}

final class TodayFortuneUseCase: TodayFortuneUseCaseProtocol {
    private let repository: TodayFortuneRepositoryProtocol
    
    init(repository: TodayFortuneRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchTodayFortune(
        date: String,
        time: Int?,
        gender: String,
        favoriteTeam: String
    ) -> Single<Fortune> {
        self.repository.fetchTodayFortune(
            date: date,
            time: time,
            gender: gender,
            favoriteTeam: favoriteTeam
        )
    }
}
