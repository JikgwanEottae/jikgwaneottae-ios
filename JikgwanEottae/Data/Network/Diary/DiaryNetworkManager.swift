//
//  DiaryManager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/2/25.
//

import Foundation

import Moya
import RxSwift

// MARK: - 직관 일기 네트워크 매니저

final class DiaryNetworkManager {
    static let shared = DiaryNetworkManager()
    private let provider: MoyaProvider<DiaryAPIService>
    
    private init() {
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdGl0Y2g4OTcxQGdhY2hvbi5hYy5rciIsImlhdCI6MTc1NDQ2ODYwOCwiZXhwIjoxNzU1MDczNDA4fQ.zYI4NGahrvpUWOn4saEJqWQ6tr_Fw_cUEqVm1Kblg_k"
        let authPlugin = AccessTokenPlugin { _ in token }
        self.provider = MoyaProvider(plugins: [authPlugin])
    }
    
    /// 전체 직관 일기를 가져오는 함수
    public func fetchAllDiaries() -> Single<[Diary]> {
        return provider.rx.request(.fetchAllDiaries)
            .map(DiaryResponseDTO.self)
            .map { $0.toDomain() }
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
    }
    
    /// 해당 날짜의 모든 직관 일기를 가져오는 함수
    public func fetchDiaries(year: String, month: String) -> Single<[Diary]> {
        return provider.rx.request(.fetchDiaries(year: year, month: month))
            .map(DiaryResponseDTO.self)
            .map { $0.toDomain() }
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
    }
    
}
