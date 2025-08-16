//
//  DiaryCreateRequestDTO.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/10/25.
//

import Foundation

// MARK: - 직관 일기 요청 DTO를 관리합니다.

// MARK: - 직관 일기 생성 요청 DTO입니다.

struct DiaryCreateRequestDTO: Encodable {
    let gameId: Int?
    let favoriteTeam: String
    let seat: String
    let memo: String
}

// MARK: - 직관 일기 수정 요청 DTO입니다.

struct DiaryUpdateRequestDTO: Encodable {
    let favoriteTeam: String
    let seat: String
    let memo: String
    let isImageRemoved: Bool
}
