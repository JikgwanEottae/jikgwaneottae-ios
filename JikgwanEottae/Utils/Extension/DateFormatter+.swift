//
//  DateFormatter+.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/23/25.
//

import Foundation

extension DateFormatter {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = .current
        return formatter
    }()
    static func getDateFormatter() -> DateFormatter { return dateFormatter }
}

