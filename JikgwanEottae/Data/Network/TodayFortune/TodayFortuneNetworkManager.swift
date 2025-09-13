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
        self.provider = MoyaProvider(session: Session(interceptor: AuthInterceptor.shared))
    }
    
    public func fetchTodayFortune(params: TodayFortuneRequestDTO) -> Single<Fortune> {
        self.provider.rx.request(.fetchTodayFortune(params: params))
            .map(TodayFortuneResponseDTO.self)
            .map { $0.toDomain() }
    }
}
