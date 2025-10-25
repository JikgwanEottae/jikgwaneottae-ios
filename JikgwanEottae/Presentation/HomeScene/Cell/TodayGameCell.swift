//
//  TodayGameCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/4/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 오늘의 야구 경기 일정을 보여주기 위한 커스텀 컬렉션 뷰 셀입니다.

final class TodayGameCell: UICollectionViewCell {
    static let ID = "TodayGameCell"
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        statusContainerView,
        homeStackView,
        awayStackView,
        ballparkLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.alignment = .leading
        $0.distribution = .fillEqually
    }
    
    private let statusContainerView = UIView().then {
        $0.backgroundColor = UIColor.Background.badgeColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
    }
    
    private let statusLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 11, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = UIColor.white
        $0.clipsToBounds = true
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    
    private lazy var homeStackView = UIStackView(arrangedSubviews: [
        homeTeamNameLabel,
        homeTeamScoreLabel
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let homeTeamNameLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 17, family: .bold)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.clipsToBounds = true
    }
    
    private let homeTeamScoreLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 20, family: .bold)
        $0.textColor = UIColor.Text.primaryColor
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.clipsToBounds = true
    }
    
    private lazy var awayStackView = UIStackView(arrangedSubviews: [
        awayTeamNameLabel,
        awayTeamScoreLabel
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.alignment = .fill
    }
    
    private let awayTeamNameLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 17, family: .bold)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.clipsToBounds = true
    }
    
    private let awayTeamScoreLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 20, family: .bold)
        $0.textColor = UIColor.Text.primaryColor
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.clipsToBounds = true
    }
    
    private let ballparkLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 12, family: .medium)
        $0.textColor = UIColor.Text.secondaryColor
        $0.numberOfLines = 1
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        homeTeamNameLabel.text = nil
        homeTeamScoreLabel.text = nil
        awayTeamNameLabel.text = nil
        awayTeamScoreLabel.text = nil
        statusLabel.text = nil
    }
    
    private func addSubviews() {
        contentView.addSubview(stackView)
        statusContainerView.addSubview(statusLabel)
    }
    
    private func setupUI() {
        self.layer.cornerRadius = Constants.cornerRadius
        self.backgroundColor = .secondaryBackgroundColor
    }
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
        homeStackView.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
        }
    
        
        awayStackView.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
        }
        
        statusLabel.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(6)
            make.top.bottom
                .equalToSuperview()
                .inset(4)
        }
    }
    
    public func configure(game: KBOGame) {
        if game.status == "PLAYED" { statusLabel.text = "경기종료" }
        else if game.status == "SCHEDULED" { statusLabel.text = "경기예정" }
        else if game.status == "CANCELED" { statusLabel.text = "경기취소" }
        else { statusLabel.text = "기타" }
        homeTeamNameLabel.text = game.homeTeam
        homeTeamNameLabel.textColor = KBOTeam(rawValue: game.homeTeam)?.color
        if let homeScore = game.homeScore { homeTeamScoreLabel.text = "\(homeScore)" }
        awayTeamNameLabel.text = game.awayTeam
        awayTeamNameLabel.textColor = KBOTeam(rawValue: game.awayTeam)?.color
        if let awayScore = game.awayScore { awayTeamScoreLabel.text = "\(awayScore)" }
        ballparkLabel.text = game.ballpark
    }
    
}
