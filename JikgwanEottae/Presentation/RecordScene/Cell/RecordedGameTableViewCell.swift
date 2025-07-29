//
//  RecordedGameTableViewCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/26/25.
//

import UIKit

import SnapKit
import Then

final class RecordedGameTableViewCell: UITableViewCell {
    // 셀 아이디
    static let ID = "RecordedGameTableViewCell"
    
    private lazy var containerStackView = UIStackView(
        arrangedSubviews: [
            teamInfoStackView,
            ballParkLabel,
            startTimeLabel
        ]
    ).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 5
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 0, left: 27, bottom: 0, right: 27)
    }
    
    private lazy var teamInfoStackView = UIStackView(
        arrangedSubviews: [
            homeTeamLabel,
            awayTeamLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 10
    }
    
    // 홈 팀 레이블
    private let homeTeamLabel = UILabel().then {
        $0.text = "삼성    12"
//        $0.font = .pretendard(size: 15, family: .bold)
        $0.font = .gMarketSans(size: 15, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .secondaryTextColor
        $0.clipsToBounds = true
    }
    
    // 어웨이 팀 레이블
    private let awayTeamLabel = UILabel().then {
        $0.text = "SSG    3"
//        $0.font = .pretendard(size: 15, family: .bold)
        $0.font = .gMarketSans(size: 15, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .systemGray4
        $0.clipsToBounds = true
    }
    
    // 야구장 이름 레이블
    private let ballParkLabel = UILabel().then {
        $0.text = "대구삼성라이온즈파크"
//        $0.font = .pretendard(size: 14, family: .bold)
        $0.font = .gMarketSans(size: 15, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .secondaryTextColor
        $0.clipsToBounds = true
    }
    
    // 경기 시각 레이블
    private let startTimeLabel = UILabel().then {
        $0.text = "18:00"
//        $0.font = .pretendard(size: 14, family: .bold)
        $0.font = .gMarketSans(size: 15, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .secondaryTextColor
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
            by: .init(top: 0, left: 0, bottom: 20, right: 0)
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        homeTeamLabel.text = nil
        awayTeamLabel.text = nil
        ballParkLabel.text = nil
        startTimeLabel.text = nil
    }
    
    private func addSubviews() {
        contentView.addSubview(containerStackView)
    }
    
    private func setupUI() {
        contentView.layer.borderColor = UIColor.mainCharcoalColor.cgColor
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.layer.borderWidth = 2
        contentView.clipsToBounds = true
        selectionStyle = .none
    }
    
    private func setupLayout() {
        containerStackView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
    public func configure(num: String) {
        homeTeamLabel.text = "삼성    12"
        awayTeamLabel.text = "SSG    4"
        ballParkLabel.text = "대구삼성라이온즈파크"
        startTimeLabel.text = "18:00"
    }
    
}

