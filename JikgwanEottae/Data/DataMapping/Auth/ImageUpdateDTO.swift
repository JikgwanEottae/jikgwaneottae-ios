//
//  ImageUpdateDTO.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/11/25.
//

import Foundation

struct ImageUpdateDTO: Decodable {
    let result: Bool
    let httpCode: Int
    let data: ImageUpdateDataDTO
    let message: String
}

extension ImageUpdateDTO {
    struct ImageUpdateDataDTO: Decodable {
        let profileImageURL: String?
        
        private enum CodingKeys: String, CodingKey {
            case profileImageURL = "url"
        }
    }
}
