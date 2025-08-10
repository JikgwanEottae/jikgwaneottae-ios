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
    // 전체 직관 일기 조회
    case fetchAllDiaries
    // 해당 연·월 직관 일기 조회
    case fetchDiaries(
        year: String,
        month: String
    )
    // 직관 일기 생성
    case createDiary(
        diaryCreateRequestDTO: DiaryCreateRequestDTO,
        photoData: Data?
    )
}

extension DiaryAPIService: TargetType, AccessTokenAuthorizable {
    // 기본 URL
    var baseURL: URL {
        URL(string: "https://contributors-gentleman-david-packs.trycloudflare.com")!
    }
    // 엔드 포인트
    var path: String {
        switch self {
        case .fetchAllDiaries:
            return "/api/diaries"
        case .fetchDiaries:
            return "/api/diaries/month"
        case .createDiary:
            return "/api/diaries"
        }
    }
    // HTTP 메소드
    var method: Moya.Method {
        switch self {
        case .fetchAllDiaries:
            return .get
        case .fetchDiaries:
            return .get
        case .createDiary:
            return .post
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
        case .createDiary(let diaryCreateRequestDTO, let photoData):
            let json = try! JSONEncoder().encode(diaryCreateRequestDTO)
            var multipartFormData: [MultipartFormData] = []
            multipartFormData.append(
                MultipartFormData(
                    provider: .data(json),
                    name: "dto",
                    fileName: "dto.json",
                    mimeType: "application/json"
                )
            )
            if let photoData = photoData {
                multipartFormData.append(
                    MultipartFormData(
                        provider: .data(photoData),
                        name: "file",
                        fileName: "photo.jpg",
                        mimeType: "image/jpeg"
                    )
                )
            }
            return .uploadMultipart(multipartFormData)
        }
    }
    // 헤더
    var headers: [String : String]? {
        switch self {
        case .fetchAllDiaries:
            return ["Content-Type": "application/json"]
        case .fetchDiaries:
            return ["Content-Type": "application/json"]
        case .createDiary:
            return ["Content-Type": "multipart/form-data"]
        }
    }
    // 토큰
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        case .fetchAllDiaries:
            return .bearer
        case .fetchDiaries:
            return .bearer
        case .createDiary:
            return .bearer
        }
    }
    
}
