//
//  DiaryManager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/2/25.
//

import Foundation

import Moya
import RxSwift

final class DiaryManager {
    // 싱글톤
    static let shared = DiaryManager()
    private let provider = MoyaProvider<DiaryAPIService>()
    
    private init() { }
    
    // 직관 일기 가져오기
    public func fetchDiary() -> Single<[Diary]> {
        provider.rx.request(.fetchDiary)
            .map(DiaryResponseDTO.self)
            .map { $0.toDomain() }
    }
    
    
    
}
