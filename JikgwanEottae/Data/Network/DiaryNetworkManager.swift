//
//  DiaryManager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/2/25.
//

import Foundation

import Moya
import RxSwift

final class DiaryNetworkManager {
    static let shared = DiaryNetworkManager()
    private let provider: MoyaProvider<DiaryAPIService>
    
    private init() {
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdGl0Y2g4OTcxQGdhY2hvbi5hYy5rciIsImlhdCI6MTc1NDE1Nzk4NCwiZXhwIjoxNzU0MjQ0Mzg0fQ.xY5SYPZFvZpiSdu-0auyCPL78UZ3-VBlkBzE9QYOeZk"
        let authPlugin = AccessTokenPlugin { _ in token }
        self.provider = MoyaProvider(plugins: [authPlugin])
    }
    
    // 전체 직관 일기 가져오기
    public func fetchAllDiaries() -> Single<[Diary]> {
        provider.rx.request(.fetchAllDiaries)
            .map(DiaryResponseDTO.self)
            .map { $0.toDomain() }
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
    }
    
    // 해당 날짜 직관 일기 가져오기
    public func fetchDiaries(year: String, month: String) -> Single<[Diary]> {
        provider.rx.request(.fetchDiaries(year: year, month: month))
            .map(DiaryResponseDTO.self)
            .map { $0.toDomain() }
            .subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
    }
    
}
