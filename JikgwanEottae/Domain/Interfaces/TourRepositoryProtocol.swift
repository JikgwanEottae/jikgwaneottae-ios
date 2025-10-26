//
//  TourRepositoryProtocol.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/23/25.
//

import Foundation

import RxSwift

// MARK: - 국문관광정보 TourAPI 프로토콜(인터페이스)입니다.

protocol TourRepositoryProtocol {
    /// 위치기반 관광정보를 조회합니다.
    func fetchTourPlacesByLocation(
        pageNo: Int,
        coordinate: Coordinate,
        radius: Int,
        tourType: TourType
    ) -> Single<TourPlacePage>
    
    /// 공통 관광정보를 조회합니다.
    func fetchTourPlaceCommonDetail(
        contentID: String
    ) -> Single<TourPlacePage>
    
    /// 구단 주변 인기 연관 관광지 TOP 50을 조회합니다.
    func fetchNearbyTourPlace(
        team: String
    ) -> Single<NearbyTourPlace>
}
