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
        let token = KeychainManager.shared.readAccessToken() ?? ""
        let authPlugin = AccessTokenPlugin { _ in token }
        self.provider = MoyaProvider(plugins: [authPlugin])
    }
    
    public func fetchTodayFortune(params: TodayFortuneRequestDTO) -> Single<Fortune> {
        self.provider.rx.request(.fetchTodayFortune(params: params))
            .map(TodayFortuneResponseDTO.self)
            .map { $0.toDomain() }
    }
}
