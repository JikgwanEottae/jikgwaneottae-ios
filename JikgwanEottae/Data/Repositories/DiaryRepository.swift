//
//  DiaryRepository.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/3/25.
//

import Foundation

import RxSwift

// MARK: - 직관 일기 리포지토리입니다.

final class DiaryRepository: DiaryRepositoryProtocol {
    private let networkManger: DiaryNetworkManager
    private let diaryCache = DiaryCache.shared
    
    init(networkManger: DiaryNetworkManager) {
        self.networkManger = networkManger
    }
    
    public func fetchAllDiaries() -> Single<[Diary]> {
        return self.networkManger.fetchAllDiaries()
    }
    
    public func fetchDiaries(selectedMonth: Date) -> Single<[Diary]> {
        let key = selectedMonth.toFormattedString("yyyy-MM")
        // 캐시된 데이터가 있다면, 네트워크 호출없이 해당 데이터를 조회합니다.
        if let cached = diaryCache.getMonthlyDiaries(for: key) {
            print("캐시 히트: \(key)")
            return .just(cached)
        }
        print("캐시 미스: \(key)")
        // 캐시된 데이터가 없다면, 네트워크 호출로 데이터를 조회합니다.
        let (year, month) = selectedMonth.toYearMonth()
        return networkManger.fetchDiaries(year: year, month: month)
            .do(onSuccess: { [weak self] diaries in
                // 네트워크 호출 이후 해당 데이터를 캐싱합니다.
                print("캐싱: \(key)")
                self?.diaryCache.setMonthlyDiaries(diaries, for: key)
            })
    }
    
    public func fetchDiaries(selectedDay: Date) -> [Diary] {
        let dayKey = selectedDay.toFormattedString("yyyy-MM-dd")
        let monthKey = String(dayKey.prefix(7))
        return diaryCache.getDailyDiaries(for: dayKey, in: monthKey)
    }
    
    public func createDiary(gameId: Int, favoriteTeam: String, seat: String, memo: String, imageData: Data?) -> Completable {
        let dto = DiaryCreateRequestDTO(gameId: gameId, favoriteTeam: favoriteTeam, seat: seat, memo: memo)
        return self.networkManger.createDiary(dto: dto, imageData: imageData)
    }
    
    public func updateDiary(diaryId: Int, favoriteTeam: String, seat: String, memo: String, imageData: Data?, isImageRemoved: Bool) -> Completable {
        let dto = DiaryUpdateRequestDTO(favoriteTeam: favoriteTeam, seat: seat, memo: memo, isImageRemoved: isImageRemoved)
        return self.networkManger.updateDiary(diaryId: diaryId, dto: dto, imageData: imageData)
    }
    
    public func deleteDiary(diaryId: Int) -> Completable {
        return self.networkManger.deleteDiary(diaryId: diaryId)
    }
    
    public func fetchDiaryStats() -> Single<DiaryStats> {
        return self.networkManger.fetchDiaryStats()
    }
}

