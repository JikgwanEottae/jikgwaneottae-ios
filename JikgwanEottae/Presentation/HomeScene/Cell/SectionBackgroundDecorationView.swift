//
//  SectionBackgroundDecorationView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/18/25.
//

import UIKit

// MARK: -  컬렉션 뷰의 섹션에 배경을 적용하기 위한 뷰입니다.

final class SectionBackgroundDecorationView: UICollectionReusableView {
    static let kind = "SectionBackgroundDecorationView"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.layer.cornerRadius = 25
        self.clipsToBounds = true
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError( "init(coder:) has not been implemented" )
    }
    
}
