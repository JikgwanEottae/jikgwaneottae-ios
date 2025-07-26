//
//  Team.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/25/25.
//

import Foundation

// MARK: - KBO 구단

enum KBOTeam: String, CaseIterable, Codable {
    case doosan = "두산"
    case lg = "LG"
    case kiwoom = "키움"
    case samsung = "삼성"
    case lotte = "롯데"
    case kia = "KIA"
    case hanwha = "한화"
    case ssg = "SSG"
    case nc = "NC"
    case kt = "KT"
    
    var ballpark: String {
        switch self {
        case .doosan:
            return "서울잠실야구장"
        case .lg:
            return "서울잠실야구장"
        case .kiwoom:
            return "고척스카이돔"
        case .samsung:
            return "대구삼성라이온즈파크"
        case .lotte:
            return "사직야구장"
        case .kia:
            return "광주기아챔피언스필드"
        case .hanwha:
            return "대전한화생명볼파크"
        case .ssg:
            return "인천SSG랜더스필드"
        case .nc:
            return "창원NC파크"
        case .kt:
            return "수원케이티위즈파크"
        }
    }
}
