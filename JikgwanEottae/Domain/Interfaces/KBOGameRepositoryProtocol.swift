//
//  KBOGameRepositoryProtocol.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/7/25.
//

import Foundation

import RxSwift
import RxCocoa

// MARK: - KBO 경기 정보 프로토콜(인터페이스)입니다.

protocol KBOGameRepositoryProtocol {
    /// 특정 일자(ex: 2025-08-01) KBO 경기를 조회합니다.
    func fetchDailyGames(date: Date) -> Single<[KBOGame]>
    
    /// 특정 연·월 KBO 경기를 조회합니다.
    func fetchMonthlyGames(date: Date) -> Single<[KBOGame]>
}
