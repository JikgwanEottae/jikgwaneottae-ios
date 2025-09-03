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
    
    init(networkManger: DiaryNetworkManager) {
        self.networkManger = networkManger
    }
    
    public func fetchAllDiaries() -> Single<[Diary]> {
        return self.networkManger.fetchAllDiaries()
    }
    
    public func fetchDiaries(
        year: String,
        month: String
    ) -> Single<[Diary]> {
        return self.networkManger.fetchDiaries(year: year, month: month)
    }
    
    public func createDiary(
        gameId: Int,
        favoriteTeam: String,
        seat: String,
        memo: String,
        imageData: Data?
    ) -> Completable {
        let dto = DiaryCreateRequestDTO(
            gameId: gameId,
            favoriteTeam: favoriteTeam,
            seat: seat,
            memo: memo
        )
        return self.networkManger.createDiary(
            dto: dto,
            imageData: imageData
        )
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
        return self.networkManger.updateDiary(diaryId: diaryId, dto: dto, imageData: imageData)
    }
    
    public func deleteDiary(diaryId: Int) -> Completable {
        return self.networkManger.deleteDiary(diaryId: diaryId)
    }
    
    public func fetchDiaryStats() -> Single<DiaryStats> {
        return self.networkManger.fetchDiaryStats()
    }
}

