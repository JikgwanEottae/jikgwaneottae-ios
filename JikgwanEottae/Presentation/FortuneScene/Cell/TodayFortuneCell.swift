//
//  TodayFortuneCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/1/25.
//

import UIKit

import Then
import SnapKit

// MARK: - 오늘의 직관 운세를 보여주기 위한 커스텀 컬렉션 뷰 셀입니다.

final class TodayFortuneCell: UICollectionViewCell {
    
    static let ID = "TodayFortuneCell"
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "clover")?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = UIColor.Custom.shamrockGreen
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        titleLabel,
        chevronImageView
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .center
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "혹시 내가 오늘의 승리 요정"
        $0.font = UIFont.pretendard(size: 16, family: .semiBold)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.textAlignment = .left
        $0.numberOfLines = 1
        $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private let chevronImageView = UIImageView().then {
        let config = UIImage.SymbolConfiguration(pointSize: 14, weight: .semibold)
        $0.image = UIImage(
            systemName: "chevron.right",
            withConfiguration: config)?.withTintColor(
                UIColor.Text.tertiaryColor,
                renderingMode: .alwaysOriginal
            )
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
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
        self.contentView.backgroundColor = UIColor.Background.secondaryColor
        self.contentView.layer.cornerRadius = Constants.cornerRadius
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(stackView)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.leading
                .equalToSuperview()
                .inset(25)
            make.centerY
                .equalToSuperview()
            make.size
                .equalTo(45)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom
                .equalToSuperview()
            make.leading
                .equalTo(imageView.snp.trailing)
                .offset(25)
            make.trailing
                .equalToSuperview()
                .inset(25)
        }
    }
}

