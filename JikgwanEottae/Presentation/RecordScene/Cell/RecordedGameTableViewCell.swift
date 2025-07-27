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
            ballParkAndTimeLabel,
            checkboxButton
        ]
    ).then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 10
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = .init(top: 0, left: 30, bottom: 0, right: 30)
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
        $0.text = "삼성           12"
        $0.font = .pretendard(size: 15, family: .bold)
        $0.numberOfLines = 1
        $0.textColor = .secondaryTextColor
        $0.clipsToBounds = true
    }
    
    // 어웨이 팀 레이블
    private let awayTeamLabel = UILabel().then {
        $0.text = "SSG          3"
        $0.font = .pretendard(size: 15, family: .bold)
        $0.numberOfLines = 1
        $0.textColor = .systemGray4
        $0.clipsToBounds = true
    }
    
    // 야구장 이름 그리고 시작 시간 레이블
    private let ballParkAndTimeLabel = UILabel().then {
        $0.text = "대구삼성라이온즈파크"
        $0.font = .pretendard(size: 14, family: .bold)
        $0.numberOfLines = 1
        $0.textColor = .secondaryTextColor
        $0.clipsToBounds = true
    }
    // 셀 선택 표시 체크박스
    private let checkboxButton = UIButton(type: .custom).then {
        let image = UIImage(named: "checkbox")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.tintColor = .mainCharcoalColor
        $0.contentMode = .scaleAspectFit
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
        homeTeamLabel.text = nil
        awayTeamLabel.text = nil
        ballParkAndTimeLabel.text = nil
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
        checkboxButton.snp.makeConstraints { make in
            make.size
                .equalTo(20)
        }
    }
    
    public func configure(num: String) {
        let image = UIImage(named: "emptybox")?.withRenderingMode(.alwaysTemplate)
        checkboxButton.setImage(image, for: .normal)
        checkboxButton.tintColor = .borderColor
        contentView.layer.borderColor = UIColor.borderColor.cgColor
    }
    
}

