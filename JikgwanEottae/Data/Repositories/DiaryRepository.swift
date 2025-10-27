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
    private let diaryCacheManager = DiaryCache.shared
    
    init(networkManger: DiaryNetworkManager) {
        self.networkManger = networkManger
    }
    
    public func fetchAllDiaries() -> Single<[Diary]> {
        return networkManger.fetchAllDiaries()
    }

    
    public func fetchFilteredDiaries(
        _ filterType: DiaryFilterType
    ) -> Single<[Diary]> {
        return networkManger.fetchFilteredDiaries(filterType)
    }
    
    public func fetchDiaries(selectedMonth: Date) -> Single<[Diary]> {
        let key = selectedMonth.toFormattedString("yyyy-MM")
        // 캐시된 데이터가 있다면, 네트워크 호출없이 해당 데이터를 조회합니다.
        if let cached = diaryCacheManager.getMonthlyDiaries(for: key) {
            return .just(cached)
        }
        // 캐시된 데이터가 없다면, 네트워크 호출로 데이터를 조회합니다.
        let (year, month) = selectedMonth.toYearMonth()
        return networkManger.fetchDiaries(year: year, month: month)
            .do(onSuccess: { [weak self] diaries in
                // 네트워크 호출 이후 해당 데이터를 캐싱합니다.
                self?.diaryCacheManager.setMonthlyDiaries(diaries, for: key)
            })
    }
    
    public func fetchDiaries(selectedDay: Date) -> [Diary] {
        let dayKey = selectedDay.toFormattedString("yyyy-MM-dd")
        let monthKey = String(dayKey.prefix(7))
        return diaryCacheManager.getDailyDiaries(for: dayKey, in: monthKey)
    }
    
    public func createDiary(
        gameID: Int,
        title: String,
        favoriteTeam: String,
        seat: String,
        content: String,
        photoData: Data?
    ) -> Completable {
        let dto = DiaryCreationRequestDTO(
            gameId: gameID,
            title: title,
            favoriteTeam: favoriteTeam,
            seat: seat,
            content: content
        )
        return networkManger.createDiary(dto: dto, imageData: photoData)
            .do(onSuccess: { [weak self] diary in
                guard let self = self,
                      let diary = diary.first
                else { return }
                let monthKey = String(diary.gameDate.prefix(7))
                self.diaryCacheManager.appendDiary(diary, for: monthKey)
                AppState.shared.needsDiaryRefresh = true
                AppState.shared.needsStatisticsRefresh = true
            })
            .asCompletable()
    }
    
    public func updateDiary(
        diaryId: Int,
        title: String,
        favoriteTeam: String,
        seat: String,
        content: String,
        photoData: Data?,
        isImageRemoved: Bool
    ) -> Completable {
        let dto = DiaryUpdateRequestDTO(
            title: title,
            favoriteTeam: favoriteTeam,
            seat: seat,
            content: content,
            isImageRemoved: isImageRemoved
        )
        return self.networkManger.updateDiary(
            diaryId: diaryId,
            dto: dto,
            photoData: photoData
        )
        .do(onSuccess: { [weak self] _ in
            AppState.shared.needsDiaryRefresh = true
            AppState.shared.needsStatisticsRefresh = true
        })
        .asCompletable()
    }
    
    public func deleteDiary(
        diaryId: Int
    ) -> Completable {
        return self.networkManger.deleteDiary(diaryId: diaryId)
            .do(onCompleted: { [weak self] in
                AppState.shared.needsDiaryRefresh = true
                AppState.shared.needsStatisticsRefresh = true
            })
    }
    
    public func fetchDiaryStats() -> Single<DiaryStats> {
        return self.networkManger.fetchDiaryStats()
    }
}

