//
//  DiaryUseCase.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/3/25.
//

import Foundation

import RxSwift
import RxCocoa

// MARK: - DiaryUseCase 프로토콜

protocol DiaryUseCaseProtocol {
    func fetchAllDiaries() -> Single<[Diary]>
    func fetchDiaries(year: String, month: String) -> Single<[Diary]>
}

// MARK: - DiaryUseCase. DiaryUseCaseProtocol를 채택

final class DiaryUseCase: DiaryUseCaseProtocol {
    private let repository: DiaryRepositoryProtocol
    
    // DiaryRepositoryProtocol을 채택한 repository 주입
    init(repository: DiaryRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchAllDiaries() -> Single<[Diary]> {
        return self.repository.fetchAllDiaries()
    }
    
    public func fetchDiaries(year: String, month: String) -> Single<[Diary]> {
        return self.repository.fetchDiaries(year: year, month: month)
    }
    
}
