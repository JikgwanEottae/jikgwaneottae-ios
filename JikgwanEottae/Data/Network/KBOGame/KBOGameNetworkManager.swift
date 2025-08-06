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
        let token = ""
        let authPlugin = AccessTokenPlugin { _ in token }
        self.provider = MoyaProvider(plugins: [authPlugin])
    }
    
    /// 특정 일자 KBO 경기를 조회하기
    public func fetchDailyGames(date: Date) -> Single<[KBOGame]> {
        return provider.rx.request(.fetchDailyGames(date))
            .map(KBOGameResponseDTO.self)
            .map { $0.toDomain() }
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
    }

    
}
