//
//  DiaryRepositoryProtocol.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/3/25.
//

import Foundation

// MARK: - 직관 일기 프로토콜(인터페이스)

protocol DiaryRepositoryProtocol {
    // 전체 직관 일기 가져오기
    func fetchAllDiaries() -> [Diary]
    // 해당 연도-월 직관 일기 가져오기
    func fetchDiaries(year: String, month: String) -> [Diary]
}
