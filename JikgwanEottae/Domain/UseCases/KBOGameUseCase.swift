//
//  KBOGameUseCase.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/7/25.
//

import Foundation

import RxSwift
import RxCocoa

// MARK: - KBO 경기 정보 유스케이스 프로토콜

protocol KBOGameUseCaseProtocol {
    func fetchDailyGames(date: Date) -> Single<[KBOGame]>
    
    func fetchMonthlyGames(date: Date) -> Single<[KBOGame]>
}

// MARK: - KBO 경기 정보 유스케이스

final class KBOGameUseCase: KBOGameUseCaseProtocol {
    private let repository: KBOGameRepositoryProtocol
    
    init(repository: KBOGameRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchDailyGames(date: Date) -> Single<[KBOGame]> {
        return repository.fetchDailyGames(date: date)
    }
    
    public func fetchMonthlyGames(date: Date) -> Single<[KBOGame]> {
        return repository.fetchMonthlyGames(date: date)
    }
}
