//
//  TourUseCase.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/23/25.
//

import Foundation

import RxSwift

// MARK: - TourUseCase의 유스케이스 프로토콜입니다.

protocol TourUseCaseProtocol {
    /// 관광 타입과 위치를 기반으로 주변 관광지 정보를 조회합니다.
    func fetchTourPlacesByLocation(
        pageNo: Int,
        longitude: Double,
        latitude: Double,
        radius: Int,
        tourType: TourType
    ) -> Single<TourPlacePage>
}


// MARK: - 한국 관광 공사의 국문관광정보 TourAPI에 사용할 유스케이스입니다.

final class TourUseCase: TourUseCaseProtocol {
    private let repository: TourRepositoryProtocol
    
    init(repository: TourRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchTourPlacesByLocation(
        pageNo: Int,
        longitude: Double,
        latitude: Double,
        radius: Int = 3000,
        tourType: TourType
    ) -> Single<TourPlacePage> {
        return self.repository.fetchTourPlacesByLocation(
            pageNo: pageNo,
            longitude: longitude,
            latitude: latitude,
            radius: radius,
            tourType: tourType
        )
    }
    
}
