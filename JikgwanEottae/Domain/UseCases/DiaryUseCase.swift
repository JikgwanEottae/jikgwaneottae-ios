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
    
    func fetchFilteredDiaries(
        _ filterType: DiaryFilterType
    ) -> Single<[Diary]>

    func fetchDiaries(
        selectedMonth: Date
    ) -> Single<[Diary]>
    
    func fetchDailyDiaries(
        selectedDay: Date
    ) -> [Diary]
    
    func createDiary(
        gameID: Int,
        title: String,
        favoriteTeam: String,
        seat: String,
        content: String,
        photoData: Data?
    ) -> Completable
    
    func updateDiary(
        diaryId: Int,
        title: String,
        favoriteTeam: String,
        seat: String,
        content: String,
        photoData: Data?,
        isImageRemoved: Bool
    ) -> Completable
    
    func deleteDiary(
        diaryId: Int,
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
        return repository.fetchAllDiaries()
    }
    
    public func fetchFilteredDiaries(
        _ filterType: DiaryFilterType
    ) -> Single<[Diary]> {
        return repository.fetchFilteredDiaries(filterType)
    }
    
    public func fetchDiaries(
        selectedMonth: Date
    ) -> Single<[Diary]> {
        return repository.fetchDiaries(selectedMonth: selectedMonth)
    }
    
    public func fetchDailyDiaries(
        selectedDay: Date
    ) -> [Diary] {
        return repository.fetchDiaries(selectedDay: selectedDay)
    }
    
    public func createDiary(
        gameID: Int,
        title: String,
        favoriteTeam: String,
        seat: String,
        content: String,
        photoData: Data?
    ) -> Completable {
        return repository.createDiary(
            gameID: gameID,
            title: title,
            favoriteTeam: favoriteTeam,
            seat: seat,
            content: content,
            photoData: photoData
        )
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
        return repository.updateDiary(
            diaryId: diaryId,
            title: title,
            favoriteTeam: favoriteTeam,
            seat: seat,
            content: content,
            photoData: photoData,
            isImageRemoved: isImageRemoved
        )
    }
    
    public func deleteDiary(
        diaryId: Int
    ) -> Completable {
        return repository.deleteDiary(
            diaryId: diaryId
        )
    }
    
    public func fetchDiaryStats() -> Single<DiaryStats> {
        return repository.fetchDiaryStats()
    }
}
