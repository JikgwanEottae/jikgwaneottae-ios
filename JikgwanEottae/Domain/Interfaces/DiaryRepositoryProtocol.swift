//
//  DiaryRepositoryProtocol.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/3/25.
//

import Foundation

import RxSwift
import RxCocoa

// MARK: - 직관 일기 프로토콜(인터페이스)

protocol DiaryRepositoryProtocol {
    /// 전체 직관 일기 조회
    func fetchAllDiaries() -> Single<[Diary]>
    
    /// 해당 연도-월 직관 일기 조회
    func fetchDiaries(
        year: String,
        month: String
    ) -> Single<[Diary]>
    
    /// 직관 일기 생성
    func createDiary(
        gameId: Int,
        favoriteTeam: String,
        seat: String?,
        memo: String?,
        photoData: Data?
    ) -> Completable
    
    /// 직관 일기 삭제
    func deleteDiary(
        diaryId: Int
    ) -> Completable
}
