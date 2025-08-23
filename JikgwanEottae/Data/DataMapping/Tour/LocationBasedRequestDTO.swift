//
//  LocationBasedRequestDTO.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/24/25.
//

import Foundation

// MARK: - 위치기반 관광정보 조회 요청 DTO입니다.

struct LocationBasedRequestDTO: Encodable {
    let pageNo: Int
    let serviceKey: String
    let mapX: Double
    let mapY: Double
    let radius: Int
    let contentTypeId: String
}

extension LocationBasedRequestDTO {
    func toDictionary() -> [String: Any] {
        return [
            "numOfRows": "30",
            "pageNo": pageNo,
            "MobileOS": "IOS",
            "MobileApp": "AppTest",
            "serviceKey": serviceKey,
            "_type": "json",
            "arrange": "E",
            "mapX": mapX,
            "mapY": mapY,
            "radius": radius,
            "contentTypeId": contentTypeId
        ]
    }
}
