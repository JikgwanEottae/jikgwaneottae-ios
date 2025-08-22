//
//  TourPlace.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/23/25.
//

import Foundation

// MARK: - 관광 정보 엔티티입니다.

struct TourPlacePage {
    let pageNo: Int // 페이지 번호
    let totalCount: Int // 전체 데이터 수
    let numOfRows: Int // 받은 데이터 수
    let TourPlaces: [TourPlace]
}

struct TourPlace: Equatable {
    let id: Int // 콘텐츠 아이디
    let categoryID: Int // 관광 타입 아이디
    let title: String // 제목
    let address: String // 주소
    let latitude: Double // 위도
    let longitude: Double // 경도
    let imageURL: String? // 썸네일 이미지 주소
}
