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
        coordinate: Coordinate,
        tourType: TourType
    ) -> Single<TourPlacePage>
    
    /// 컨텐츠 아이디를 기반으로 공통 관광 정보를 조회합니다.
    func fetchTourPlaceCommonDetail(
        contentID: String
    ) -> Single<TourPlacePage>
    
    /// 구단 주변 인기 연관 관광지 TOP 50을 조회합니다.
    func fetchNearbyTourPlace(
        team: String
    ) -> Single<NearbyTourPlace>
}


// MARK: - 한국 관광 공사의 국문관광정보 TourAPI에 사용할 유스케이스입니다.

final class TourUseCase: TourUseCaseProtocol {
    private let repository: TourRepositoryProtocol
    
    init(repository: TourRepositoryProtocol) {
        self.repository = repository
    }
    
    public func fetchTourPlacesByLocation(
        pageNo: Int,
        coordinate: Coordinate,
        tourType: TourType
    ) -> Single<TourPlacePage> {
        let radius: Int = 3000
        return repository.fetchTourPlacesByLocation(
            pageNo: pageNo,
            coordinate: coordinate,
            radius: radius,
            tourType: tourType
        )
    }
    
    public func fetchTourPlaceCommonDetail(
        contentID: String
    ) -> Single<TourPlacePage> {
        return repository.fetchTourPlaceCommonDetail(contentID: contentID)
    }
    
    public func fetchNearbyTourPlace(
        team: String
    ) -> Single<NearbyTourPlace> {
        return repository.fetchNearbyTourPlace(team: team)
    }
    
}
