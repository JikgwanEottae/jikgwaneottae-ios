//
//  TourRepository.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/24/25.
//

import Foundation

import RxSwift

// MARK: - 국문관광정보 TourAPI 리포지토리입니다.

final class TourRepository: TourRepositoryProtocol {
    private let manager: TourNetworkManager
    
    init(manager: TourNetworkManager) {
        self.manager = manager
    }
    
    public func fetchTourPlacesByLocation(
        pageNo: Int,
        longitude: Double,
        latitude: Double,
        radius: Int,
        contentTypeId: Int
    ) -> Single<TourPlacePage> {
        let tourApiKey = Bundle.main.object(forInfoDictionaryKey: "TourApiKey") as! String
        let locationBasedRequestDTO = LocationBasedRequestDTO(
            pageNo: pageNo,
            serviceKey: tourApiKey,
            mapX: longitude,
            mapY: latitude,
            radius: radius,
            contentTypeId: contentTypeId
        )
        return self.manager.fetchTourPlacesByLocation(params: locationBasedRequestDTO)
    }
}
