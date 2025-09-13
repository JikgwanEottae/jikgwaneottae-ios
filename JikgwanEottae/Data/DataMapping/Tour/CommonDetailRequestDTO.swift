//
//  CommonDetailRequestDTO.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/30/25.
//

import Foundation


// MARK: - 공통관광정보 요청 DTO입니다.

struct CommonDetailRequestDTO: Encodable {
    let serviceKey: String
    let contentID: String
}

extension CommonDetailRequestDTO {
    func toDictionary() -> [String: Any] {
        return [
            "numOfRows": 1,
            "pageNo": 1,
            "MobileOS": "IOS",
            "MobileApp": "AppTest",
            "serviceKey": serviceKey,
            "_type": "json",
            "contentId": contentID
        ]
    }
}
