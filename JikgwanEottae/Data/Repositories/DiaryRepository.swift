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
    private let diaryNetworkManger: DiaryNetworkManager
    
    init(diaryNetworkManger: DiaryNetworkManager) {
        self.diaryNetworkManger = diaryNetworkManger
    }
    
    func fetchAllDiaries() -> Single<[Diary]> {
        return self.diaryNetworkManger.fetchAllDiaries()
    }
    
    func fetchDiaries(year: String, month: String) -> Single<[Diary]> {
        return self.diaryNetworkManger.fetchDiaries(year: year, month: month)
    }
    
}
