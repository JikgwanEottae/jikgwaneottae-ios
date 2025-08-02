//
//  DiaryAPISerview.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/2/25.
//

import Foundation

import Moya

// MARK: - 직관 일기 API 서비스

enum DiaryAPIService {
    // 전체 직관 일기 가져오기
    case fetchAllDiaries
    // 해당 연도.월 직관 일기 가져오기
    case fetchDiaries(String, String)
}

extension DiaryAPIService: TargetType {
    // 기본 URL
    var baseURL: URL {
        URL(string: "https://api.jikgwaneottae.com/")!
    }
    // 엔드 포인트
    var path: String {
        switch self {
        case .fetchAllDiaries:
            return "/api/diaries"
        case .fetchDiaries:
            return "/api/diaries/calendar"
        }
    }
    // HTTP 메소드
    var method: Moya.Method {
        switch self {
        case .fetchAllDiaries:
            return .get
        case .fetchDiaries:
            return .get
        }
    }
    // 요청 파라미터
    var task: Task {
        switch self {
        case .fetchAllDiaries:
            return .requestPlain
        case .fetchDiaries(let year, let month):
            let params = [
                "year": year,
                "month": month
            ]
            return .requestParameters(
                parameters: params,
                encoding: URLEncoding.queryString
            )
        }
    }
    // 헤더
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
}
