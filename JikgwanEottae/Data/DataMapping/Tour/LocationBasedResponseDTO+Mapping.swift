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
        let resultCode: String
        let resultMsg: String
    }
    
    struct BodyDTO: Decodable {
        let numOfRows: Int
        let pageNo: Int
        let totalCount: Int
        let items: ItemsDTO
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
        let baseAddress: String
        let subAddress: String
        let zipCode: String
        let latitude: String
        let longitude: String
        let distance: String
        let imageURL: String
        
        private enum CodingKeys: String, CodingKey {
            case id = "contentid"
            case categoryID = "contenttypeid"
            case title
            case baseAddress = "addr1"
            case subAddress = "addr2"
            case zipCode = "zipcode"
            case latitude = "mapy"
            case longitude = "mapx"
            case distance = "dist"
            case imageURL = "firstimage"
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
            baseAddress: baseAddress,
            subAddress: subAddress,
            zipCode: zipCode,
            latitude: Double(latitude),
            longitude: Double(longitude),
            distance: Double(distance),
            imageURL: imageURL,
            overview: nil
        )
    }
}
