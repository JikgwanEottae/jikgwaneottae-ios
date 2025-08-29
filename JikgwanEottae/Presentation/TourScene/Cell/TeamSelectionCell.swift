//
//  TeamSelectionCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/17/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 구단별 관광지 조회 섹션에서 사용할 커스텀 컬렉션 뷰 셀입니다.

final class TeamSelectionCell: UICollectionViewCell {
    // 셀 재사용 아이디입니다.
    static let ID = "TeamSelectionCell"
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        teamNameLabel,
        ballparkLabel
    ]).then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    // 구단 이름 레이블입니다.
    private let teamNameLabel = UILabel().then {
        $0.font = .gMarketSans(size: 20, family: .bold)
        $0.textColor = .secondaryTextColor
        $0.textAlignment = .left
    }
    
    // 구장 레이블입니다.
    private let ballparkLabel = UILabel().then {
        $0.font = .gMarketSans(size: 12, family: .medium)
        $0.textColor = .secondaryTextColor
        $0.textAlignment = .left
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        teamNameLabel.text = nil
        ballparkLabel.text = nil
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.backgroundColor = .secondaryBackgroundColor
        contentView.layer.masksToBounds = true
        [stackView].forEach { self.contentView.addSubview($0) }
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(20)
        }
    }
    
    /// 구단의 이름과 대표 색상으로 셀을 초기화합니다.
    public func configure(team: KBOTeam) {
        teamNameLabel.text = team.rawValue
        teamNameLabel.textColor = team.color
        ballparkLabel.text = team.ballpark
    }
}
