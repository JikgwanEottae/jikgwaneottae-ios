//
//  DiaryManager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/2/25.
//

import Foundation

import Moya
import RxSwift

final class DiaryNetworkManager {
    static let shared = DiaryNetworkManager()
    private let provider = MoyaProvider<DiaryAPIService>()
    
    private init() { }
    
    // 전체 직관 일기 가져오기
    public func fetchAllDiaries() -> Single<[Diary]> {
        provider.rx.request(.fetchAllDiaries)
            .map(DiaryResponseDTO.self)
            .map { $0.toDomain() }
    }
    
    // 해당 날짜 직관 일기 가져오기
    public func fetchDiaries(year: String, month: String) -> Single<[Diary]> {
        provider.rx.request(.fetchDiaries(year: year, month: month))
            .map(DiaryResponseDTO.self)
            .map { $0.toDomain() }
    }
    
}
