//
//  DiaryRepository.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/3/25.
//

import Foundation

import RxSwift
import RxCocoa

// MARK: - 직관 일기 리포지토리 구현체

final class DiaryRepository: DiaryRepositoryProtocol {
    private let networkManger: DiaryNetworkManager
    
    init(networkManger: DiaryNetworkManager) {
        self.networkManger = networkManger
    }
    
    /// 전체 직관 일기 조회 구현체입니다.
    public func fetchAllDiaries() -> Single<[Diary]> {
        return self.networkManger.fetchAllDiaries()
    }
    
    /// 해당 연·월 직관 일기 조회 구현체입니다.
    public func fetchDiaries(
        year: String,
        month: String
    ) -> Single<[Diary]> {
        return self.networkManger.fetchDiaries(year: year, month: month)
    }
    
    /// 직관 일기 생성 구현체입니다.
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
    
    /// 직관 일기 수정 구현체입니다.
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
    
    /// 직관 일기 삭제 구현체입니다.
    public func deleteDiary(diaryId: Int) -> Completable {
        return self.networkManger.deleteDiary(diaryId: diaryId)
    }
}

