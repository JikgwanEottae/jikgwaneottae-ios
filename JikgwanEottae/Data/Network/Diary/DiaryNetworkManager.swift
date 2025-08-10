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
        let token = "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdGl0Y2g4OTcxQGdhY2hvbi5hYy5rciIsImlhdCI6MTc1NDY1NzM5MCwiZXhwIjoxNzU1MjYyMTkwfQ.9DQWrGKa0jdDNWg1pKMHowMGPT8rZwadGJbB1J0NKyk"
        let authPlugin = AccessTokenPlugin { _ in token }
        self.provider = MoyaProvider(plugins: [authPlugin])
    }
    
    public func fetchAllDiaries() -> Single<[Diary]> {
        return provider.rx.request(.fetchAllDiaries)
            .map(DiaryResponseDTO.self)
            .map { $0.toDomain() }
    }
    
    public func fetchDiaries(
        year: String,
        month: String
    ) -> Single<[Diary]> {
        return provider.rx.request(.fetchDiaries(year: year, month: month))
            .map(DiaryResponseDTO.self)
            .map { $0.toDomain() }
    }
    
    public func createDiary(
        diaryCreateRequestDTO: DiaryCreateRequestDTO,
        photoData: Data?
    ) -> Completable {
        return provider.rx.request(
            .createDiary(diaryCreateRequestDTO: diaryCreateRequestDTO, photoData: photoData))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
    
}
