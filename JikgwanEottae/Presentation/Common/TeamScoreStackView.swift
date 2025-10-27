//
//  TeamScoreStackView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/7/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 구단 이름과 점수를 수평으로 나열하는 스택뷰

final class TeamScoreStackView: UIStackView {
    private let teamLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 25, family: .semiBold)
        $0.textColor = UIColor.Text.secondaryColor
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }
    
    private let scoreLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 25, family: .semiBold)
        $0.textColor = UIColor.Text.secondaryColor
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        axis = .horizontal
        distribution = .equalSpacing
        alignment = .fill
        spacing = 10
        addArrangedSubview(teamLabel)
        addArrangedSubview(scoreLabel)
    }

    public func configure(team: String, score: Int?) {
        teamLabel.text = team
        teamLabel.textColor = KBOTeam(rawValue: team)?.color
        scoreLabel.textColor = KBOTeam(rawValue: team)?.color
        if let score = score {
            scoreLabel.text = String(score)
            scoreLabel.isHidden = false
        } else {
            scoreLabel.text = nil
            scoreLabel.isHidden = true
        }
    }
}

