//
//  SectionSeparatorView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/18/25.
//

import UIKit

// MARK: - 컬렉션 뷰의 섹션 사이 구분선을 적용할 뷰입니다.

final class SectionSeparatorView: UICollectionReusableView {
    // 섹션의 푸터로 등록합니다.
    static let elementKind = UICollectionView.elementKindSectionFooter
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .primaryBackgroundColor
        self.layer.masksToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
