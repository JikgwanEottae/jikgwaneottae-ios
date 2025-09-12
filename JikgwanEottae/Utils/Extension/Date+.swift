//
//  DateFormatter+.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import Foundation

extension Date {
    func toFormattedString(_ dateFormat: String) -> String {
        let dateFormatter = DateFormatter.getDateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.string(from: self)
    }
    
    func toYearMonth() -> (year: String, month: String) {
        let components = self.toFormattedString("yyyy-MM")
            .split(separator: "-")
            .map { String($0) }
        return (year: components[0], month: components[1])
    }
}
