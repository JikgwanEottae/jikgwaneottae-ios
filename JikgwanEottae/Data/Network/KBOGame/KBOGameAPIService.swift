//
//  KBOGameAPIService.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/6/25.
//

import Foundation

import Moya

// MARK: - KBO 경기 정보 API 서비스

enum KBOGameAPIService {
    // 특정 일자 KBO 경기 조회
    case fetchDailyGames(Date)
    // 특정 연·월 KBO 경기 조회
    case fetchMonthlyGames(Date)
}

extension KBOGameAPIService: TargetType, AccessTokenAuthorizable {
    var baseURL: URL {
        URL(string: "https://api.jikgwaneottae.xyz")!
    }
    
    var path: String {
        switch self {
        case .fetchDailyGames(let date):
            return "/api/games/date/\(date.toFormattedString("yyyy-MM-dd"))"
        case .fetchMonthlyGames:
            return "/api/games/calendar"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchDailyGames:
            return .get
        case .fetchMonthlyGames:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchDailyGames:
            return .requestPlain
        case .fetchMonthlyGames(let date):
            let formattedDateStr = date.toFormattedString("yyyy-MM").split(separator: "-").map { String($0) }
            let year = formattedDateStr[0]
            let month = formattedDateStr[1]
            let params = ["year": year, "month": month]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        case .fetchDailyGames:
            return .bearer
        case .fetchMonthlyGames:
            return .bearer
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
