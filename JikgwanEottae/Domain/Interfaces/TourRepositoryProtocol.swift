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
        longitude: Double,
        latitude: Double,
        radius: Int,
        contentTypeId: Int
    ) -> Single<TourPlacePage>
}
