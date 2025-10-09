//
//  KBOGameCollectionViewCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/7/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 경기 일정 조회를 담당하는 컬렉션 뷰 셀입니다.

final class KBOGameCollectionViewCell: UICollectionViewCell {
    static let ID = "KBOGameCollectionViewCell"
    
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            statusContainerView,
            homeStackView,
            awayStackView,
            infoLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalSpacing
    }
    
    private let statusContainerView = UIVisualEffectView().then {
        $0.effect =  UIBlurEffect(style: .dark)
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    private let statusLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 12, family: .medium)
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.textColor = .white
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
        $0.font = UIFont.pretendard(size: 24, family: .semiBold)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.clipsToBounds = true
    }
    
    private let homeTeamScoreLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 24, family: .semiBold)
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
        $0.font = UIFont.pretendard(size: 24, family: .semiBold)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.clipsToBounds = true
    }
    
    private let awayTeamScoreLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 24, family: .semiBold)
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.clipsToBounds = true
    }
    
    private let infoLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
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
        self.contentView.frame = self.contentView.frame.inset(
            by: UIEdgeInsets(
                top: 15,
                left: 15,
                bottom: 15,
                right: 15
            )
        )
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
        statusContainerView.contentView.addSubview(statusLabel)
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
        
        statusLabel.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(6)
            make.top.bottom
                .equalToSuperview()
                .inset(4)
            make.center
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
        
        infoLabel.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
        }
    }
    
    public func configure(game: KBOGame) {
        if game.status == "PLAYED" { statusLabel.text = "경기종료" }
        else if game.status == "SCHEDULED" { statusLabel.text = "경기예정" }
        else if game.status == "CANCELED" { statusLabel.text = "경기취소" }
        
        homeTeamNameLabel.text = game.homeTeam
        homeTeamNameLabel.textColor = KBOTeam(rawValue: game.homeTeam)?.color
        awayTeamNameLabel.text = game.awayTeam
        awayTeamNameLabel.textColor = KBOTeam(rawValue: game.awayTeam)?.color
        
        if let homeScore = game.homeScore {
            homeTeamScoreLabel.text = "\(homeScore)"
            homeTeamScoreLabel.textColor =  KBOTeam(rawValue: game.homeTeam)?.color
        }
        
        if let awayScore = game.awayScore {
            awayTeamScoreLabel.text = "\(awayScore)"
            awayTeamScoreLabel.textColor =  KBOTeam(rawValue: game.awayTeam)?.color
        }
        
        infoLabel.text = "\(game.ballpark) | \(game.gameTime)"
    }
    
}
