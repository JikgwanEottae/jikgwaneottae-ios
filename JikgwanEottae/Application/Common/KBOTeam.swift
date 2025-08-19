//
//  Team.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/25/25.
//

import Foundation
import UIKit

// MARK: - KBO 구단

enum KBOTeam: String, CaseIterable, Hashable {
    case doosan = "두산"
    case kiwoom = "키움"
    case samsung = "삼성"
    case lotte = "롯데"
    case kia = "KIA"
    case hanwha = "한화"
    case ssg = "SSG"
    case nc = "NC"
    case lg = "LG"
    case kt = "KT"
    
    var ballpark: String {
        switch self {
        case .doosan:
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
        case .lg:
            return "서울잠실야구장"
        case .kt:
            return "수원케이티위즈파크"
        }
    }
    
    var color: UIColor {
        switch self {
        case .doosan:
            return #colorLiteral(red: 0.1019607843, green: 0.09019607843, blue: 0.2823529412, alpha: 1)
        case .kiwoom:
            return #colorLiteral(red: 0.3411764706, green: 0.01960784314, blue: 0.07843137255, alpha: 1)
        case .samsung:
            return #colorLiteral(red: 0.02745098039, green: 0.2980392157, blue: 0.631372549, alpha: 1)
        case .lotte:
            return #colorLiteral(red: 0.01568627451, green: 0.1176470588, blue: 0.2588235294, alpha: 1)
        case .kia:
            return #colorLiteral(red: 0.9176470588, green: 0, blue: 0.1607843137, alpha: 1)
        case .hanwha:
            return #colorLiteral(red: 0.9882352941, green: 0.3058823529, blue: 0, alpha: 1)
        case .ssg:
            return #colorLiteral(red: 0.8078431373, green: 0.05490196078, blue: 0.1764705882, alpha: 1)
        case .nc:
            return #colorLiteral(red: 0.192, green: 0.322, blue: 0.533, alpha: 1)
        case .lg:
            return #colorLiteral(red: 0.7647058824, green: 0.01568627451, blue: 0.3215686275, alpha: 1)
        case .kt:
            return #colorLiteral(red: 0.000, green: 0.000, blue: 0.000, alpha: 1)
        }
    }
    
    var coordinate: (latitude: Double, longitude: Double) {
        switch self {
        case .doosan:
            return (37.5119858, 127.0718388)
        case .kiwoom:
            return (37.4982105, 126.8672613)
        case .samsung:
            return (35.8410706, 128.6817523)
        case .lotte:
            return (35.1931684, 129.0615852)
        case .kia:
            return (35.1682116, 126.8891068)
        case .hanwha:
            return (36.3163197, 127.4313789)
        case .ssg:
            return (37.4368605, 126.6932818)
        case .nc:
            return (35.2224951, 128.5825537)
        case .lg:
            return (37.5119858, 127.0718388)
        case .kt:
            return (37.3000960, 127.0096588)
        }
    }
}
