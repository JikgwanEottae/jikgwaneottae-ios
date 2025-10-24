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
    func fetchAllDiaries() -> Single<[Diary]>
    
    /// 필터에 따른 직관 일기를 조회합니다.
    func fetchFilteredDiaries(
        _ filterType: DiaryFilterType
    ) -> Single<[Diary]>
    
    /// 해당 연도-월 직관 일기를 조회합니다.
    func fetchDiaries(
        selectedMonth: Date
    ) -> Single<[Diary]>
    
    /// 해당 날짜의 직관 일기를 조횝합니다.
    func fetchDiaries(
        selectedDay: Date
    ) -> [Diary]
    
    /// 직관 일기를 생성합니다.
    func createDiary(
        gameID: Int,
        title: String,
        favoriteTeam: String,
        seat: String,
        content: String,
        photoData: Data?
    ) -> Completable
    
    /// 직관 일기를 수정합니다.
    func updateDiary(
        diaryId: Int,
        title: String,
        favoriteTeam: String,
        seat: String,
        content: String,
        photoData: Data?,
        isImageRemoved: Bool
    ) -> Completable
    
    /// 직관 일기를 삭제합니다.
    func deleteDiary(
        diaryId: Int
    ) -> Completable
    
    /// 직관 일기 승률을 조회합니다.
    func fetchDiaryStats() -> Single<DiaryStats>
}
