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
        return self.networkManger.fetchAllDiaries()
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
        favoriteTeam: String,
        seat: String,
        memo: String,
        imageData: Data?
    ) -> Completable {
        let dto = DiaryCreationRequestDTO(
            gameId: gameID,
            favoriteTeam: favoriteTeam,
            seat: seat,
            memo: memo
        )
        return networkManger.createDiary(dto: dto, imageData: imageData)
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
        favoriteTeam: String,
        seat: String,
        memo: String,
        imageData: Data?,
        isImageRemoved: Bool
    ) -> Completable {
        let dto = DiaryUpdateRequestDTO(
            favoriteTeam: favoriteTeam,
            seat: seat,
            memo: memo,
            isImageRemoved: isImageRemoved
        )
        return self.networkManger.updateDiary(
            diaryId: diaryId,
            dto: dto,
            imageData: imageData
        )
        .do(onSuccess: { [weak self] diary in
            guard let self = self,
                  let diary = diary.first
            else { return }
            let monthKey = String(diary.gameDate.prefix(7))
            self.diaryCacheManager.updateDiary(diary, for: monthKey)
            AppState.shared.needsDiaryRefresh = true
            AppState.shared.needsStatisticsRefresh = true
        })
        .asCompletable()
    }
    
    public func deleteDiary(
        diaryID: Int,
        gameDate: String
    ) -> Completable {
        return self.networkManger.deleteDiary(diaryID: diaryID)
            .do(onCompleted: { [weak self] in
                let monthKey = String(gameDate.prefix(7))
                self?.diaryCacheManager.removeDiary(id: diaryID, for: monthKey)
                AppState.shared.needsDiaryRefresh = true
                AppState.shared.needsStatisticsRefresh = true
            })
    }
    
    public func fetchDiaryStats() -> Single<DiaryStats> {
        return self.networkManger.fetchDiaryStats()
    }
}

