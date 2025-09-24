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
        $0.tintColor = .shamrockGreen
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        titleLabel,
        subtitleLabel
    ]).then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "혹시 내가 오늘의 승리 요정?"
        $0.font = .paperlogy(size: 16, family: .medium)
        $0.textColor = .primaryTextColor
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "운세보기"
        $0.font = .paperlogy(size: 17, family: .semiBold)
        $0.textColor = .shamrockGreen
        $0.textAlignment = .left
        $0.numberOfLines = 1
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
        self.contentView.backgroundColor = .secondaryBackgroundColor
        self.contentView.layer.cornerRadius = Constants.cornerRadius
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(stackView)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.leading.top.bottom
                .equalToSuperview()
            make.width
                .equalTo(imageView.snp.height)
        }
        stackView.snp.makeConstraints { make in
            make.centerY
                .equalToSuperview()
            make.leading
                .equalTo(imageView.snp.trailing)
                .offset(10)
            make.trailing
                .equalToSuperview()
                .offset(-10)
            make.height
                .equalTo(43)
        }
    }
}
