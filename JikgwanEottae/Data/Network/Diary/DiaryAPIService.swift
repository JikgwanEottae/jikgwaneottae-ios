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
    // 전체 직관 일기를 조회합니다.
    case fetchAllDiaries
    // 해당 연·월 직관 일기를 조회합니다.
    case fetchDiaries(year: String, month: String)
    // 직관 일기를 생성합니다.
    case createDiary(dto: DiaryCreationRequestDTO, imageData: Data?)
    // 직관 일기를 수정합니다.
    case updateDiary(diaryId: Int, dto: DiaryUpdateRequestDTO, imageData: Data?)
    // 직관 일기를 삭제합니다.
    case deleteDiary(DiaryID: Int)
    // 직관 일기 통계를 조회합니다.
    case fetchDiaryStats
}

extension DiaryAPIService: TargetType, AccessTokenAuthorizable {
    // 기본 URL을 설정합니다.
    var baseURL: URL {
        URL(string: "https://api.jikgwaneottae.xyz")!
    }
    
    // 엔드 포인트를 설정합니다.
    var path: String {
        switch self {
        case .fetchAllDiaries:
            return "/api/diaries"
        case .fetchDiaries:
            return "/api/diaries/month"
        case .createDiary:
            return "/api/diaries"
        case .updateDiary(let diaryId, _, _):
            return "/api/diaries/\(diaryId)"
        case .deleteDiary(let diaryID):
            return "/api/diaries/\(diaryID)"
        case .fetchDiaryStats:
            return "/api/diaries/stats"
        }
    }
    
    // HTTP 메소드를 설정합니다.
    var method: Moya.Method {
        switch self {
        case .fetchAllDiaries, .fetchDiaries, .fetchDiaryStats:
            return .get
        case .createDiary:
            return .post
        case .updateDiary:
            return .patch
        case .deleteDiary:
            return .delete
        }
    }
    
    // 바디를 설정합니다.
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
        case .createDiary(let dto, let imageData):
            let json = try! JSONEncoder().encode(dto)

            var multipartFormData: [MultipartFormData] = []
            multipartFormData.append(
                MultipartFormData(
                    provider: .data(json),
                    name: "dto",
                    fileName: "dto.json",
                    mimeType: "application/json"
                )
            )
            if let data = imageData {
                multipartFormData.append(
                    MultipartFormData(
                        provider: .data(data),
                        name: "file",
                        fileName: "photo.jpg",
                        mimeType: "image/jpeg"
                    )
                )
            }
            return .uploadMultipart(multipartFormData)
            
        case .updateDiary(_, let dto, let imageData):
            var multipartFormData: [MultipartFormData] = []
            let json = try! JSONEncoder().encode(dto)
            multipartFormData.append(
                MultipartFormData(
                    provider: .data(json),
                    name: "dto",
                    fileName: "dto.json",
                    mimeType: "application/json"
                )
            )
            if let data = imageData {
                multipartFormData.append(
                    MultipartFormData(
                        provider: .data(data),
                        name: "file",
                        fileName: "photo.jpg",
                        mimeType: "image/jpeg"
                    )
                )
            }
            return .uploadMultipart(multipartFormData)
            
        case .deleteDiary:
            return .requestPlain
            
        case .fetchDiaryStats:
            return .requestPlain
        }
    }
    
    // 헤더를 설정합니다.
    var headers: [String : String]? {
        switch self {
        case .fetchAllDiaries, .fetchDiaries, .deleteDiary, .fetchDiaryStats:
            return ["Content-Type": "application/json"]
        case .createDiary, .updateDiary:
            return ["Content-Type": "multipart/form-data"]
        }
    }
    
    // 토큰을 설정합니다.
    var authorizationType: Moya.AuthorizationType? {
        switch self {
        case .fetchAllDiaries, .fetchDiaries, .createDiary, .updateDiary, .deleteDiary, .fetchDiaryStats:
            return .bearer
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
