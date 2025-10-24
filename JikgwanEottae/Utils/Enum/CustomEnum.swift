//
//  SortOrder.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/15/25.
//

import Foundation

// 일기 정렬 타입
enum DiarySortOrder {
    case latest
    case oldest
}

// 일기 필터 타입
enum DiaryFilterType: String {
    case all
    case win = "WIN"
    case loss = "LOSS"
    case draw = "DRAW"
}
