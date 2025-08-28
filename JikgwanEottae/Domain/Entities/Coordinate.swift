//
//  Coordinate.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/25/25.
//

import Foundation

// MARK: - 좌표(위도, 경도) 엔티티

struct Coordinate: Hashable {
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
