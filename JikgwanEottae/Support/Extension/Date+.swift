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
}
