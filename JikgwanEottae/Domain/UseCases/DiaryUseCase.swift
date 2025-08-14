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
    
    func fetchDiaries(
        year: String,
        month: String
    ) -> Single<[Diary]>
    
    func createDiary(
        gameId: Int,
        favoriteTeam: String,
        seat: String?,
        memo: String?,
        photoData: Data?
    ) -> Completable
    
    func deleteDiary(
        diaryId: Int
    ) -> Completable
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
    
    public func fetchDiaries(
        year: String,
        month: String
    ) -> Single<[Diary]> {
        return self.repository.fetchDiaries(
            year: year,
            month: month
        )
    }
    
    public func createDiary(
        gameId: Int,
        favoriteTeam: String,
        seat: String?,
        memo: String?,
        photoData: Data?
    ) -> Completable {
        return self.repository.createDiary(
            gameId: gameId,
            favoriteTeam: favoriteTeam,
            seat: seat,
            memo: memo,
            photoData: photoData
        )
    }
    
    public func deleteDiary(
        diaryId: Int
    ) -> Completable {
        return self.repository.deleteDiary(diaryId: diaryId)
    }
}
