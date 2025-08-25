//
//  LocationBasedReponseDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/23/25.
//

import Foundation

// MARK: - 위치기반 관광정보 조회 Response DTO입니다.

struct LocationBasedResponseDTO: Decodable {
    let response: ResponseDTO
    
    struct ResponseDTO: Decodable {
        let header: HeaderDTO
        let body: BodyDTO
        
        struct HeaderDTO: Decodable {
            let resultCode: String // 결과 코드
            let resultMsg: String // 결과 메시지
        }
        
        struct BodyDTO: Decodable {
            let items: ItemsDTO
            let numOfRows: Int // 한 페이지 결과 수
            let pageNo: Int // 페이지 번호
            let totalCount: Int // 전체 결과 수
            
            struct ItemsDTO: Decodable {
                let item: [TourPlaceDTO]
                
                struct TourPlaceDTO: Decodable {
                    let id: String // 콘텐츠 아이디
                    let categoryID: String // 관광 타입 아이디
                    let title: String // 제목
                    let address: String // 주소
                    let latitude: String // 위도
                    let longitude: String // 경도
                    let imageURL: String? // 썸네일 이미지 주소
                    
                    private enum CodingKeys: String, CodingKey {
                        case id = "contentid"
                        case categoryID = "contenttypeid"
                        case title
                        case address = "addr1"
                        case latitude = "mapy"
                        case longitude = "mapx"
                        case imageURL = "firstimage"
                    }
                }
            }
        }
    }
}

extension LocationBasedResponseDTO {
    func toDomain() -> TourPlacePage {
        return response.body.toDomain()
    }
}

extension LocationBasedResponseDTO.ResponseDTO.BodyDTO {
    func toDomain() -> TourPlacePage {
        return TourPlacePage(
            pageNo: pageNo,
            totalCount: totalCount,
            numOfRows: numOfRows,
            TourPlaces: items.item.map{ $0.toDomain() }
        )
    }
}

extension LocationBasedResponseDTO.ResponseDTO.BodyDTO.ItemsDTO.TourPlaceDTO {
    func toDomain() -> TourPlace {
        return TourPlace(
            id: Int(id)!,
            categoryID: Int(categoryID)!,
            title: title,
            address: address,
            latitude: Double(latitude)!,
            longitude: Double(longitude)!,
            imageURL: imageURL)
    }
}
