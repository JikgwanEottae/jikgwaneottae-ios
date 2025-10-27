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
    
    // 직관일기를 작성했을 때, 통계 데이터를 패치할지 여부를 체크합니다.
    var needsStatisticsRefresh: Bool = true
    
    // 직관 일기를 작성하고, 캘린더가 갱신이 필요한지 여부를 체크합니다.
    var needsDiaryRefresh: Bool = true
    
    // 게스트 모드 여부를 체크합니다.
    var isGuestMode: Bool = true
    
    private init() { }
    
    /// 모든 상태를 초기화합니다.
    public func clear() {
        needsStatisticsRefresh = true
        needsDiaryRefresh = true
        isGuestMode = true
    }
    
}
