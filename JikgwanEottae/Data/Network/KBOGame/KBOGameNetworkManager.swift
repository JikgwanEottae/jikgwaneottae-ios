//
//  KBOGameNetworkManager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/6/25.
//

import Foundation

import Moya
import RxSwift

// MARK: - KBO 경기 정보 네트워크 매니저

final class KBOGameNetworkManager {
    static let shared = KBOGameNetworkManager()
    private let provider: MoyaProvider<KBOGameAPIService>
    
    private init() {
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdGl0Y2g4OTcxQGdhY2hvbi5hYy5rciIsImlhdCI6MTc1NTI2NjI4NiwiZXhwIjoxNzU1ODcxMDg2fQ.QYh8duAdo6m9o_tZzMvfWsN_FDO9G5BJEVFMlJrla18"
        let authPlugin = AccessTokenPlugin { _ in token }
        self.provider = MoyaProvider(plugins: [authPlugin])
    }
    
    /// 특정 일자 KBO 경기 조회하기
    public func fetchDailyGames(date: Date) -> Single<[KBOGame]> {
        return provider.rx.request(.fetchDailyGames(date))
            .map(KBOGameResponseDTO.self)
            .map { $0.toDomain() }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
    
    /// 특정 연·월 KBO 경기 조회하기
    public func fetchMonthlyGames(date: Date) -> Single<[KBOGame]> {
        return provider.rx.request(.fetchMonthlyGames(date))
            .map(KBOGameResponseDTO.self)
            .map { $0.toDomain() }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
