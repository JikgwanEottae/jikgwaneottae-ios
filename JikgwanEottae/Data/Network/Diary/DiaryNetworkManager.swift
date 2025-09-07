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
        let token = KeychainManager.shared.readAccessToken() ?? ""
        let authPlugin = AccessTokenPlugin { _ in token }
        self.provider = MoyaProvider(plugins: [authPlugin])
    }
    
    /// 전체 직관 일기 조회를 요청합니다.
    public func fetchAllDiaries() -> Single<[Diary]> {
        return self.provider.rx.request(.fetchAllDiaries)
            .map(DiaryResponseDTO.self)
            .map { $0.toDomain() }
    }
    /// 해당 연·월 직관 일기 조회를 요청합니다
    public func fetchDiaries(
        year: String,
        month: String
    ) -> Single<[Diary]> {
        return self.provider.rx.request(.fetchDiaries(year: year, month: month))
            .map(DiaryResponseDTO.self)
            .map { $0.toDomain() }
    }
    /// 직관 일기 생성을 요청합니다.
    public func createDiary(
        dto: DiaryCreateRequestDTO,
        imageData: Data?
    ) -> Completable {
        return self.provider.rx.request(.createDiary(dto: dto, imageData: imageData))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
    /// 직관 일기 수정을 요청합니다.
    public func updateDiary(
        diaryId: Int,
        dto: DiaryUpdateRequestDTO,
        imageData: Data?
    ) -> Completable {
        return self.provider.rx.request(.updateDiary(diaryId: diaryId, dto: dto, imageData: imageData))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
    /// 직관 일기 삭제를 요청합니다.
    public func deleteDiary(
        diaryId: Int
    ) -> Completable {
        return self.provider.rx.request(.deleteDiary(DiaryId: diaryId))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
    /// 직관 일기 승률을 조회합니다.
    public func fetchDiaryStats() -> Single<DiaryStats> {
        return self.provider.rx.request(.fetchDiaryStats)
            .map(DiaryStatsResponseDTO.self)
            .map { $0.toDomain() }
    }
}
