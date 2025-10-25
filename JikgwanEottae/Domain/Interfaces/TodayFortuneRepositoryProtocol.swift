//
//  TodayFortuneRepositoryProtocol.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/3/25.
//

import Foundation

import RxSwift
import RxCocoa

protocol TodayFortuneRepositoryProtocol {
    /// 오늘의 직관 운세를 조회합니다.
    func fetchTodayFortune(
        date: String,
        time: Int?,
        gender: String,
        favoriteTeam: String
    ) -> Single<Fortune>
}
