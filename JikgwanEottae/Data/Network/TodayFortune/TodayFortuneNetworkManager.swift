//
//  TodayFortuneNetworkManager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/3/25.
//

import Foundation

import Moya
import RxSwift

final class TodayFortuneNetworkManager {
    static let shared = TodayFortuneNetworkManager()
    private let provider: MoyaProvider<TodayFortuneAPIService>
    
    private init() {
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdGl0Y2g4OTcxQGdhY2hvbi5hYy5rciIsImlhdCI6MTc1Njg5MTY5NywiZXhwIjoxNzU2OTc4MDk3fQ.o5wPMmGgIsQmnjHTGkLi4vAG7PxkD1mgteMfd74eW48"
        let authPlugin = AccessTokenPlugin { _ in token }
        self.provider = MoyaProvider(plugins: [authPlugin])
    }
    
    public func fetchTodayFortune(params: TodayFortuneRequestDTO) -> Single<Fortune> {
        self.provider.rx.request(.fetchTodayFortune(params: params))
            .map(TodayFortuneResponseDTO.self)
            .map { $0.toDomain() }
    }
}
