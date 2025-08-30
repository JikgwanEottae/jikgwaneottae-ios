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
}

extension LocationBasedResponseDTO {
    struct ResponseDTO: Decodable {
        let header: HeaderDTO
        let body: BodyDTO
    }
}

extension LocationBasedResponseDTO.ResponseDTO {
    struct HeaderDTO: Decodable {
        let resultCode: String // 결과 코드
        let resultMsg: String // 결과 메시지
    }
    
    struct BodyDTO: Decodable {
        let items: ItemsDTO
        let numOfRows: Int // 한 페이지 결과 수
        let pageNo: Int // 페이지 번호
        let totalCount: Int // 전체 결과 수
    }
}

extension LocationBasedResponseDTO.ResponseDTO.BodyDTO {
    struct ItemsDTO: Decodable {
        let item: [TourPlaceDTO]?
        
        private enum CodingKeys: String, CodingKey {
            case item
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if(try? container.decode(String.self)) != nil {
                self.item = nil
                return
            }
            let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
            self.item = try? keyedContainer.decode([TourPlaceDTO].self, forKey: .item)
        }
    }
}

extension LocationBasedResponseDTO.ResponseDTO.BodyDTO.ItemsDTO {
    struct TourPlaceDTO: Decodable {
        let id: String
        let categoryID: String
        let title: String
        let address: String
        let latitude: String
        let longitude: String
        let distance: String
        let imageURL: String?
        let overview: String?
        
        private enum CodingKeys: String, CodingKey {
            case id = "contentid"
            case categoryID = "contenttypeid"
            case title
            case address = "addr1"
            case latitude = "mapy"
            case longitude = "mapx"
            case distance = "dist"
            case imageURL = "firstimage"
            case overview
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
            tourPlaces: items.item?.map{ $0.toDomain() } ?? []
        )
    }
}

extension LocationBasedResponseDTO.ResponseDTO.BodyDTO.ItemsDTO.TourPlaceDTO {
    func toDomain() -> TourPlace {
        return TourPlace(
            id: id,
            categoryID: categoryID,
            title: title,
            address: address,
            latitude: Double(latitude) ?? 0.0,
            longitude: Double(longitude) ?? 0.0,
            distance: Double(distance) ?? 0.0,
            imageURL: imageURL,
            overview: overview
        )
    }
}
