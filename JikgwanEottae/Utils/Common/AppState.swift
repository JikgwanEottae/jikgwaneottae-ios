//
//  AppState.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/12/25.
//

import Foundation

// MARK: - 앱의 공용 상태를 관리하는 싱글톤 클래스입니다.

final class AppState {
    static let shared = AppState()
    
    private init() { }
    
    // 직관일기를 작성했을 때, 통계 데이터를 패치할지 여부를 체크합니다.
    var needsStatisticsRefresh: Bool = true
    
}
