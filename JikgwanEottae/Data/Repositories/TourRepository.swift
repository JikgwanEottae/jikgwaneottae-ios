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
        coordinate: Coordinate,
        radius: Int,
        tourType: TourType
    ) -> Single<TourPlacePage> {
        let tourApiKey = Bundle.main.object(forInfoDictionaryKey: "TourApiKey") as! String
        let locationBasedRequestDTO = LocationBasedRequestDTO(
            pageNo: pageNo,
            serviceKey: tourApiKey,
            mapX: coordinate.longitude,
            mapY: coordinate.latitude,
            radius: radius,
            contentTypeId: toContentTypeID(from: tourType)
        )
        return self.manager.fetchTourPlacesByLocation(params: locationBasedRequestDTO)
    }
    
    public func fetchTourPlaceCommonDetail(contentID: String) -> Single<TourPlacePage> {
        let tourApiKey = Bundle.main.object(forInfoDictionaryKey: "TourApiKey") as! String
        let commonDetailRequestDTO = CommonDetailRequestDTO(
            serviceKey: tourApiKey,
            contentID: contentID
        )
        return self.manager.fetchTourPlaceCommonDetail(params: commonDetailRequestDTO)
    }
}

extension TourRepository {
    /// 관광 타입에 따라 적절한 컨텐츠 타입 ID로 변환합니다.
    private func toContentTypeID(from tourType: TourType) -> String {
        switch tourType {
        case .restaurant:
            return "39"
        case .shopping:
            return "38"
        case .touristSpot:
            return "12"
        case .culturalFacility:
            return "14"
        case .festival:
            return "15"
        case .travelCourse:
            return "25"
        case .sports:
            return "28"
        case .accommodation:
            return "32"
        }
    }
}
