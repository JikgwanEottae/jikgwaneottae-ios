//
//  KBOGameCollectionViewCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/7/25.
//

import UIKit

import SnapKit
import Then

final class KBOGameCollectionViewCell: UICollectionViewCell {
    static let ID = "KBOGameCollectionViewCell"
    
    private let statusContainerView = UIView().then {
        $0.backgroundColor = .tagBackgroundColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
    }
    
    private let statusLabel = UILabel().then {
        $0.text = "경기예정"
        $0.font = .gMarketSans(size: 13, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .white
        $0.clipsToBounds = true
    }
    
    private let homeTeamScoreView = TeamScoreStackView()
    
    private let awayTeamScoreView = TeamScoreStackView()
    
    private let versusLabel = UILabel().then {
        $0.text = "VS"
        $0.font = .gMarketSans(size: 13, family: .bold)
        $0.numberOfLines = 1
        $0.textColor = .tertiaryTextColor
        $0.clipsToBounds = true
    }
    
    private let ballparkAndGameTimeLabel = UILabel().then {
        $0.font = .gMarketSans(size: 13, family: .bold)
        $0.numberOfLines = 1
        $0.textColor = .secondaryTextColor
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupUI()
        setupLayout()
        addShadow()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame = bounds.inset(
            by: UIEdgeInsets(
                top: 5,
                left: 5,
                bottom: 5,
                right: 5
            )
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        statusLabel.text = nil
        ballparkAndGameTimeLabel.text = nil
    }
    
    private func addSubviews() {
        contentView.addSubview(statusContainerView)
        contentView.addSubview(homeTeamScoreView)
        contentView.addSubview(versusLabel)
        contentView.addSubview(awayTeamScoreView)
        contentView.addSubview(ballparkAndGameTimeLabel)
        statusContainerView.addSubview(statusLabel)
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.backgroundColor = .white
        contentView.layer.masksToBounds = true
    }
    
    private func setupLayout() {
        statusContainerView.snp.makeConstraints { make in
            make.top.leading
                .equalToSuperview()
                .offset(17)
        }
        statusLabel.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(6)
            make.top.bottom
                .equalToSuperview()
                .inset(4)
        }
        homeTeamScoreView.snp.makeConstraints { make in
            make.top
                .equalTo(statusContainerView.snp.bottom)
                .offset(20)
            make.leading.trailing
                .equalToSuperview()
                .inset(17)
        }
        versusLabel.snp.makeConstraints { make in
            make.top
                .equalTo(homeTeamScoreView.snp.bottom)
                .offset(15)
            make.leading.trailing
                .equalToSuperview()
                .inset(17)
        }
        awayTeamScoreView.snp.makeConstraints { make in
            make.top
                .equalTo(versusLabel.snp.bottom)
                .offset(15)
            make.leading.trailing
                .equalToSuperview()
                .inset(17)
        }
        ballparkAndGameTimeLabel.snp.makeConstraints { make in
            make.top
                .equalTo(awayTeamScoreView.snp.bottom)
                .offset(20)
            make.leading.trailing
                .equalToSuperview()
                .inset(17)
        }
    }
    
    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: -2, height: 2)
        layer.shadowOpacity = 0.1
        layer.shadowRadius  = 4
    }
    
    public func configure(game: KBOGame) {
        if game.status == "PLAYED" { statusLabel.text = "경기종료" }
        else if game.status == "SCHEDULED" { statusLabel.text = "경기예정" }
        else if game.status == "CANCELED" { statusLabel.text = "경기취소" }
        homeTeamScoreView.configure(team: game.homeTeam, score: game.homeScore)
        awayTeamScoreView.configure(team: game.awayTeam, score: game.awayScore)
        ballparkAndGameTimeLabel.text = game.ballpark + "    " + game.gameTime
    }
}
