//
//  TourAPIService.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/24/25.
//

import Foundation

import Moya

// MARK: - 국문관광정보 TourAPI 서비스

enum TourAPIService {
    // 위치기반 관광정보를 조회합니다.
    case fetchTourPlacesByLocation(params: LocationBasedRequestDTO)
    // 공통 관광정보를 조회합니다.
    case fetchTourPlaceCommonDetail(params: CommonDetailRequestDTO)
}

extension TourAPIService: TargetType {
    var baseURL: URL {
        URL(string: "http://apis.data.go.kr/B551011/KorService2")!
    }
    
    var path: String {
        switch self {
        case .fetchTourPlacesByLocation:
            return "/locationBasedList2"
        case .fetchTourPlaceCommonDetail:
            return "/detailCommon2"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchTourPlacesByLocation, .fetchTourPlaceCommonDetail:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchTourPlacesByLocation(let params):
            return .requestParameters(
                parameters: params.toDictionary(),
                encoding: URLEncoding.queryString
            )
        case .fetchTourPlaceCommonDetail(let params):
            return .requestParameters(
                parameters: params.toDictionary(),
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .fetchTourPlacesByLocation, .fetchTourPlaceCommonDetail:
            return nil
        }
    }
}
