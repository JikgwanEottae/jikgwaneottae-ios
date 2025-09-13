//
//  DiaryUseCase.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/3/25.
//

import Foundation

import RxSwift
import RxCocoa

// MARK: - 직관 일기 유스케이스 프로토콜

protocol DiaryUseCaseProtocol {
    func fetchAllDiaries() -> Single<[Diary]>

    func fetchDiaries(selectedMonth: Date) -> Single<[Diary]>
    
    func fetchDailyDiaries(selectedDay: Date) -> [Diary]
    
    func createDiary(gameID: Int, favoriteTeam: String, seat: String, memo: String, imageData: Data?) -> Completable
    
    func updateDiary(
        diaryId: Int,
        favoriteTeam: String,
        seat: String,
        memo: String,
        imageData: Data?,
        isImageRemoved: Bool
    ) -> Completable
    
    func deleteDiary(
        diaryID: Int,
        gameDate: String
    ) -> Completable
    
    func fetchDiaryStats() -> Single<DiaryStats>
}

// MARK: - 직관 일기 유스케이스

final class DiaryUseCase: DiaryUseCaseProtocol {
    private let repository: DiaryRepositoryProtocol
    
    init(repository: DiaryRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchAllDiaries() -> Single<[Diary]> {
        return self.repository.fetchAllDiaries()
    }
    
    public func fetchDiaries(selectedMonth: Date) -> Single<[Diary]> {
        return repository.fetchDiaries(selectedMonth: selectedMonth)
    }
    
    public func fetchDailyDiaries(selectedDay: Date) -> [Diary] {
        return repository.fetchDiaries(selectedDay: selectedDay)
    }
    
    public func createDiary(gameID: Int, favoriteTeam: String, seat: String, memo: String, imageData: Data?) -> Completable {
        return self.repository.createDiary(gameID: gameID, favoriteTeam: favoriteTeam, seat: seat, memo: memo, imageData: imageData)
    }
    
    public func updateDiary(
        diaryId: Int,
        favoriteTeam: String,
        seat: String,
        memo: String,
        imageData: Data?,
        isImageRemoved: Bool
    ) -> Completable {
        return self.repository.updateDiary(
            diaryId: diaryId,
            favoriteTeam: favoriteTeam,
            seat: seat,
            memo: memo,
            imageData: imageData,
            isImageRemoved: isImageRemoved
        )
    }
    
    public func deleteDiary(diaryID: Int, gameDate: String) -> Completable {
        return self.repository.deleteDiary(diaryID: diaryID, gameDate: gameDate)
    }
    
    public func fetchDiaryStats() -> Single<DiaryStats> {
        return self.repository.fetchDiaryStats()
    }
}
