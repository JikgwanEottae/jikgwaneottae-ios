//
//  TeamTourCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/17/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 구단별 관광지 조회 섹션에서 사용할 커스텀 컬렉션 뷰 셀입니다.

final class TeamTourCell: UICollectionViewCell {
    // 셀 재사용 아이디입니다.
    static let ID = "TeamTourCell"
    
    // 구단 심볼 버튼입니다.
    private let teamSymbolButton = UIButton(type: .custom).then {
        $0.titleLabel?.font = .kbo(size: 20, family: .bold)
        $0.backgroundColor = .secondaryBackgroundColor
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = false
    }
    
    // 구단 이름 레이블입니다.
    private let teamNameLabel = UILabel().then {
        $0.font = .gMarketSans(size: 13, family: .medium)
        $0.textColor = .primaryTextColor
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        teamNameLabel.text = nil
        teamSymbolButton.setTitle(nil, for: .normal)
        teamSymbolButton.backgroundColor = nil
    }
    
    private func setupUI() {
        contentView.addSubview(teamSymbolButton)
        contentView.addSubview(teamNameLabel)
    }
    
    private func setupLayout() {
        teamSymbolButton.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(teamSymbolButton.snp.width)
        }
        
        teamNameLabel.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(teamSymbolButton.snp.bottom).offset(10)
        }
    }
    
    /// 구단의 이름과 대표 색상으로 셀을 초기화합니다.
    public func configure(team: KBOTeam) {
        teamNameLabel.text = team.rawValue
        teamSymbolButton.setTitle(team.rawValue, for: .normal)
        teamSymbolButton.setTitleColor(team.color, for: .normal)
    }
}
