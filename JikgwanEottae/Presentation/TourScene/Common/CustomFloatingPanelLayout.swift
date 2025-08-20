//
//  CustomFloatingPanelLayout.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/21/25.
//

import UIKit

import FloatingPanel

// MARK: - 플로팅 패널에서 사용할 커스텀 레이아웃입니다.

final class CustomFloatingPanelLayout: FloatingPanelLayout {
    // 패널의 위치를 설정합니다.
    let position: FloatingPanelPosition = .bottom
    // 패널의 초기 상태를 설정합니다.
    let initialState: FloatingPanelState = .tip
    // 각 패널의 상태별 높이를 설정합니다.
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelLayoutAnchor(
                absoluteInset: 100.0,
                edge: .top,
                referenceGuide: .safeArea
            ),
            .half: FloatingPanelLayoutAnchor(
                fractionalInset: 0.4,
                edge: .bottom,
                referenceGuide: .safeArea
            ),
            .tip: FloatingPanelLayoutAnchor(
                absoluteInset: 120.0,
                edge: .bottom,
                referenceGuide: .safeArea
            )
        ]
    }
    
    /// 패널의 상태에 따라 알파값(투명도)를 설정합니다.
    /// 모두 투명하게 설정합니다.
    func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return 0.0
    }
}
