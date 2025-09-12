//
//  FortuneAPIService.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/3/25.
//

import Foundation

import Moya

enum TodayFortuneAPIService {
    // 오늘의 직관 운세 조회
    case fetchTodayFortune(params: TodayFortuneRequestDTO)
}

extension TodayFortuneAPIService: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        URL(string: "https://api.jikgwaneottae.xyz")!
    }
    var path: String {
        switch self {
        case .fetchTodayFortune:
            return "/api/saju/reading"
        }
    }
    var method: Moya.Method {
        switch self {
        case .fetchTodayFortune:
            return .post
        }
    }
    var task: Moya.Task {
        switch self {
        case .fetchTodayFortune(let params):
            return .requestJSONEncodable(params)
        }
    }
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        case .fetchTodayFortune:
            return .bearer
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
