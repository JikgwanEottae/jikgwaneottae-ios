//
//  DiaryCollectionViewCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/11/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class DiaryCollectionViewCell: UICollectionViewCell {
    static let ID = "DiaryCollectionViewCell"
    
    public let thumbnailImageView = UIImageView().then {
        $0.image = UIImage(resource: .empty)
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 14
    }
    
    private let resultContainerView = UIView().then {
        $0.backgroundColor = .tagBackgroundColor
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
    }
    
    private let resultLabel = UILabel().then {
        $0.text = "승리"
        $0.font = .gMarketSans(size: 15, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .white
        $0.clipsToBounds = true
    }
    
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            homeTeamLabel,
            homeScoreLabel,
            versusLabel,
            awayScoreLabel,
            awayTeamLabel
        ]
    ).then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.alignment = .fill
    }
    
    private let homeTeamLabel = UILabel().then {
        $0.font = .gMarketSans(size: 27, family: .bold)
        $0.textColor = .secondaryTextColor
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let homeScoreLabel = UILabel().then {
        $0.font = .gMarketSans(size: 27, family: .bold)
        $0.textColor = .secondaryTextColor
        $0.numberOfLines = 1
        $0.textAlignment = .right
    }
    
    private let versusLabel = UILabel().then {
        $0.text = "VS"
        $0.font = .gMarketSans(size: 13, family: .bold)
        $0.numberOfLines = 1
        $0.textColor = .secondaryTextColor
        $0.textAlignment = .center
        $0.clipsToBounds = true
    }
    
    private let awayScoreLabel = UILabel().then {
        $0.font = .gMarketSans(size: 27, family: .bold)
        $0.textColor = .secondaryTextColor
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let awayTeamLabel = UILabel().then {
        $0.font = .gMarketSans(size: 27, family: .bold)
        $0.textColor = .secondaryTextColor
        $0.numberOfLines = 1
        $0.textAlignment = .right
    }
    
    private let ballparkLabel = UILabel().then {
        $0.text = "대구삼성라이온즈파크"
        $0.font = .gMarketSans(size: 13, family: .bold)
        $0.numberOfLines = 1
        $0.textColor = .secondaryTextColor
        $0.textAlignment = .center
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = UIImage(resource: .empty)
        homeTeamLabel.text = nil
        awayTeamLabel.text = nil
        homeScoreLabel.text = nil
        awayScoreLabel.text = nil
        resultLabel.text = nil
        ballparkLabel.text = nil
    }
    
    private func addSubviews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(resultContainerView)
        contentView.addSubview(stackView)
        contentView.addSubview(ballparkLabel)
        resultContainerView.addSubview(resultLabel)
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = Constants.cornerRadius
        contentView.backgroundColor = .secondaryBackgroundColor
        contentView.layer.masksToBounds = true
    }
    
    private func setupLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalToSuperview()
                .inset(10)
            make.height
                .equalTo(230)
        }
        
        resultContainerView.snp.makeConstraints { make in
            make.top
                .equalTo(thumbnailImageView.snp.bottom)
                .offset(15)
            make.leading
                .equalToSuperview()
                .inset(10)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(7)
            make.top.bottom
                .equalToSuperview()
                .inset(5)
        }
        
        stackView.snp.makeConstraints { make in
            make.top
                .equalTo(resultContainerView.snp.bottom)
                .offset(15)
            make.leading.trailing
                .equalToSuperview()
                .inset(10)
        }
        
        ballparkLabel.snp.makeConstraints { make in
            make.centerX
                .equalToSuperview()
            make.top
                .equalTo(stackView.snp.bottom)
                .offset(15)
        }
    }
    
    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: -2, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius  = 5
    }
    
    public func configure(diary: Diary) {
        if let imageURLString = diary.imageURL, let imageURL = URL(string: imageURLString) {
            thumbnailImageView.kf.setImage(with: imageURL)
        }
        ballparkLabel.text = diary.ballpark
        homeTeamLabel.text = diary.homeTeam
        homeTeamLabel.textColor = KBOTeam(rawValue: diary.homeTeam)?.color
        homeScoreLabel.text = String(diary.homeScore)
        homeScoreLabel.textColor = KBOTeam(rawValue: diary.homeTeam)?.color
        awayTeamLabel.text = diary.awayTeam
        awayTeamLabel.textColor = KBOTeam(rawValue: diary.awayTeam)?.color
        awayScoreLabel.text = String(diary.awayScore)
        awayScoreLabel.textColor = KBOTeam(rawValue: diary.awayTeam)?.color
        switch diary.result {
        case "WIN":
            resultLabel.text = "승리"
            resultContainerView.backgroundColor = .tossBlueColor
        case "LOSS":
            resultLabel.text = "패배"
            resultContainerView.backgroundColor = .tossRedColor
        case "DRAW":
            resultLabel.text = "무승부"
            resultContainerView.backgroundColor = .yellowColor
        case "SCHEDULED":
            resultLabel.text = "경기예정"
            resultContainerView.backgroundColor = .mainCharcoalColor
            homeScoreLabel.textColor = .clear
            awayScoreLabel.textColor = .clear
        default:
            resultLabel.text = "경기취소"
            resultContainerView.backgroundColor = .mainCharcoalColor
            homeScoreLabel.textColor = .clear
            awayScoreLabel.textColor = .clear
        }
    }
}
