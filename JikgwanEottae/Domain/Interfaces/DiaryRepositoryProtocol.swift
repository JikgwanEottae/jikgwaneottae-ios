//
//  DiaryRepositoryProtocol.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/3/25.
//

import Foundation

import RxSwift
import RxCocoa

// MARK: - 직관 일기 프로토콜(인터페이스)입니다.

protocol DiaryRepositoryProtocol {
    /// 전체 직관 일기를 조회합니다.
    func fetchAllDiaries() -> Single<[Diary]>
    
    /// 해당 연도-월 직관 일기를 조회합니다.
    func fetchDiaries(
        year: String,
        month: String
    ) -> Single<[Diary]>
    
    /// 직관 일기를 생성합니다.
    func createDiary(
        gameId: Int,
        favoriteTeam: String,
        seat: String,
        memo: String,
        imageData: Data?
    ) -> Completable
    
    /// 직관 일기를 수정합니다.
    func updateDiary(
        diaryId: Int,
        favoriteTeam: String,
        seat: String,
        memo: String,
        imageData: Data?,
        isImageRemoved: Bool
    ) -> Completable
    
    /// 직관 일기를 삭제합니다.
    func deleteDiary(diaryId: Int) -> Completable
    
    /// 직관 일기 승률을 조회합니다.
    func fetchDiaryStats() -> Single<DiaryStats>
}
