//
//  DiarySectionHeaderView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/29/25.
//

import UIKit

import SnapKit
import Then

final class DiarySectionHeaderView: UICollectionReusableView {
    static let ID = "DiarySectionHeaderView"
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 14, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(titleLabel)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.leading
                .equalToSuperview()
                .inset(10)
            make.top.bottom.trailing.centerY
                .equalToSuperview()
        }
    }
    
    public  func configure(with yearMonth: String) {
        let parts = yearMonth.split(separator: "-")
        if parts.count == 2 {
            let year = parts[0]
            let month = parts[1]
            titleLabel.text = "\(year)년 \(month)월"
        } else {
            titleLabel.text = yearMonth
        }
    }
}
