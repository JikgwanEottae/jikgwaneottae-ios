//
//  EmptyGameCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/28/25.
//

import UIKit

import SnapKit
import Then

final class EmptyGameCell: UICollectionViewCell {
    static let ID = "EmptyGameCell"
    
    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 12
    }
    
    private let iconImageView = UIImageView().then {
        $0.image = UIImage(systemName: "calendar.badge.exclamationmark")?.withRenderingMode(.alwaysTemplate)
        $0.contentMode = .scaleAspectFit
        $0.tintColor = UIColor.Text.tertiaryColor
    }
    
    private let messageLabel = UILabel().then {
        $0.text = "오늘 예정된 경기가 없어요"
        $0.font = UIFont.pretendard(size: 12, family: .semiBold)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.textAlignment = .center
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
        contentView.backgroundColor = UIColor.Background.secondaryColor
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.addSubview(stackView)
        stackView.addArrangedSubview(iconImageView)
        stackView.addArrangedSubview(messageLabel)
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
    }
}
