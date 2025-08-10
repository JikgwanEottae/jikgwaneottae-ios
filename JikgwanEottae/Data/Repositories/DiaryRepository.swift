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
    
    public func fetchAllDiaries() -> Single<[Diary]> {
        return self.networkManger.fetchAllDiaries()
    }
    
    public func fetchDiaries(
        year: String,
        month: String
    ) -> Single<[Diary]> {
        return self.networkManger.fetchDiaries(year: year, month: month)
    }
    
    public func createDiary(
        gameId: Int,
        favoriteTeam: String,
        seat: String?,
        memo: String?,
        photoData: Data?
    ) -> Completable {
        let diaryCreateRequestDTO = DiaryCreateRequestDTO(
            gameId: gameId,
            favoriteTeam: favoriteTeam,
            seat: seat,
            memo: memo
        )
        return self.networkManger.createDiary(
            diaryCreateRequestDTO: diaryCreateRequestDTO,
            photoData: photoData
        )
    }
}
