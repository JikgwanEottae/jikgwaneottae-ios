//
//  CommonDetailResponseDTO+Mapping.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/30/25.
//

import Foundation

// MARK: - 공통정보 조회 응답 DTO입니다.

struct CommonDetailResponseDTO: Decodable {
    let response: ResponseDTO
}

extension CommonDetailResponseDTO {
    struct ResponseDTO: Decodable {
        let header: HeaderDTO
        let body: BodyDTO
    }
}

extension CommonDetailResponseDTO.ResponseDTO {
    struct HeaderDTO: Decodable {
        let resultCode: String
        let resultMsg: String
    }
    
    struct BodyDTO: Decodable {
        let numOfRows: Int
        let pageNo: Int
        let totalCount: Int
        let items: ItemDTO
    }
}

extension CommonDetailResponseDTO.ResponseDTO.BodyDTO {
    struct ItemDTO: Decodable {
        let item: [TourPlaceDTO]
    }
}

extension CommonDetailResponseDTO.ResponseDTO.BodyDTO.ItemDTO {
    struct TourPlaceDTO: Decodable {
        let id: String
        let categoryID: String
        let title: String
        let baseAddress: String
        let subAddress: String
        let zipCode: String
        let imageURL: String
        let overview: String
        
        private enum CodingKeys: String, CodingKey {
            case id = "contentid"
            case categoryID = "contenttypeid"
            case title
            case baseAddress = "addr1"
            case subAddress = "addr2"
            case zipCode = "zipcode"
            case imageURL = "firstimage"
            case overview
        }
        
    }
}

extension CommonDetailResponseDTO {
    func toDomain() -> TourPlacePage {
        return response.body.toDomain()
    }
}

extension CommonDetailResponseDTO.ResponseDTO.BodyDTO {
    func toDomain() -> TourPlacePage {
        return TourPlacePage(
            pageNo: pageNo,
            totalCount: totalCount,
            numOfRows: numOfRows,
            tourPlaces: items.item.map{ $0.toDomain() }
        )
    }
}

extension CommonDetailResponseDTO.ResponseDTO.BodyDTO.ItemDTO.TourPlaceDTO {
    func toDomain() -> TourPlace {
        return TourPlace(
            id: id,
            categoryID: categoryID,
            title: title,
            baseAddress: baseAddress,
            subAddress: subAddress,
            zipCode: zipCode,
            latitude: nil,
            longitude: nil,
            distance: nil,
            imageURL: imageURL,
            overview: overview
        )
    }
}
