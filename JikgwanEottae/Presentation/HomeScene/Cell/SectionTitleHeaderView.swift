//
//  SectionTitleHeaderView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/17/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 컬렉션 뷰의 각 섹션별 타이틀을 적용할 헤더 뷰입니다.

final class SectionTitleHeaderView: UICollectionReusableView {
    // 섹션의 헤더로 사용함을 명시합니다.
    static let elementKind = UICollectionView.elementKindSectionHeader
    
    // 섹션의 타이틀 레이블입니다.
    private let titleLabel = UILabel().then {
        $0.font = .gMarketSans(size: 16, family: .bold)
        $0.textColor = .primaryTextColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(title: String) {
        self.titleLabel.text = title
    }
}
