//
//  DiaryRepository.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/3/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DiaryRepository: DiaryRepositoryProtocol {
    private let networkManger: DiaryNetworkManager
    
    init(networkManger: DiaryNetworkManager) {
        self.networkManger = networkManger
    }
    
    func fetchAllDiaries() -> Single<[Diary]> {
        return self.networkManger.fetchAllDiaries()
    }
    
    func fetchDiaries(year: String, month: String) -> Single<[Diary]> {
        return self.networkManger.fetchDiaries(year: year, month: month)
    }
    
}
