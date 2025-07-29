//
//  RecordCollectionViewCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/24/25.
//

import UIKit

import SnapKit
import Then

final class RecordTableViewCell: UITableViewCell {
    // 셀 아이디
    static let ID = "RecordTableViewCell"
    // 최상위 스택 뷰
    private lazy var containerStackView = UIStackView(
        arrangedSubviews: [
            thumbnailImageView,
            gameInfoStackView
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
        $0.spacing = 20
    }
    // 경기 정보 전체를 감싸는 스택뷰
    private lazy var gameInfoStackView = UIStackView(
        arrangedSubviews: [
            outcomeContainerView,
            scoreLabel,
            ballParkLabel
    ]).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalSpacing
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
    }
    // 썸네일 이미지 뷰
    private let thumbnailImageView = UIImageView().then {
        $0.image = UIImage(named: "test")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 14
        $0.clipsToBounds = true
    }
    // 승패 컨테이너 뷰
    private let outcomeContainerView = UIView().then {
        $0.backgroundColor = .tossBlueColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 3
    }
    // 승패 레이블
    private let outcomeLabel = UILabel().then {
        $0.text = "승리"
//        $0.font = .pretendard(size: 11, family: .semiBold)
        $0.font = .gMarketSans(size: 11, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .white
        $0.clipsToBounds = true
    }
    // 스코어 레이블
    private let scoreLabel = UILabel().then {
        $0.text = "삼성   4 vs 1   롯데"
//        $0.font = .pretendard(size: 23, family: .bold)
        $0.font = .gMarketSans(size: 20, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .secondaryTextColor
        $0.clipsToBounds = true
    }
    // 야구장 이름 레이블
    private let ballParkLabel = UILabel().then {
        $0.text = "대구삼성라이온즈파크 18:30"
//        $0.font = .pretendard(size: 12, family: .bold)
        $0.font = .gMarketSans(size: 12, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .tertiaryTextColor
        $0.clipsToBounds = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: .init(top: 0, left: 0, bottom: 10, right: 0)
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        outcomeLabel.text = nil
        scoreLabel.text = nil
        ballParkLabel.text = nil
    }
    
    private func addSubviews() {
        contentView.addSubview(containerStackView)
        outcomeContainerView.addSubview(outcomeLabel)
    }
    
    private func setupUI() {
        contentView.backgroundColor = .secondaryBackgroundColor
        contentView.layer.borderColor = UIColor.borderColor.cgColor
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 0.75
        contentView.clipsToBounds = true
        selectionStyle = .none
    }
    
    private func setupLayout() {
        containerStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(thumbnailImageView.snp.height)
        }
        
        gameInfoStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
        }
        
        outcomeLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(6)
            make.top.bottom.equalToSuperview().inset(4)
        }
    }
    
    public func configure(str: String) {
        thumbnailImageView.image = UIImage(named: str)
        outcomeLabel.text = "승리"
        scoreLabel.text = "삼성   4 vs 1   롯데"
        ballParkLabel.text = "대구삼성라이온즈파크    18:30"
    }
    
}
