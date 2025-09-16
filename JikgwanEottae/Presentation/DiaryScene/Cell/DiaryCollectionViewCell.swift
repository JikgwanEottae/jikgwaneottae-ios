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
    
    public let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 25
        $0.clipsToBounds = true
    }
    
    public let backgroundImageView = UIImageView().then {
        $0.image = UIImage(named: "placeholder")
        $0.contentMode = .scaleAspectFill
    }
    
    private let resultContainerView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 7
    }
    
    private let resultLabel = UILabel().then {
        $0.font = .gMarketSans(size: 15, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .white
        $0.clipsToBounds = true
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    
    private let blurEffectView = UIVisualEffectView().then {
        $0.effect =  UIBlurEffect(style: .systemThickMaterialDark)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.alpha = 0.75
    }
    
    private lazy var labelsStackView = UIStackView(arrangedSubviews: [
        matchScoreLabel,
        ballparkLabel
    ]).then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
     }
    
    private let matchScoreLabel = UILabel().then {
        $0.font = .gMarketSans(size: 20, family: .bold)
        $0.numberOfLines = 1
        $0.textColor = .white
        $0.textAlignment = .left
        $0.clipsToBounds = true
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    private let ballparkLabel = UILabel().then {
        $0.font = .gMarketSans(size: 14, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .white
        $0.textAlignment = .left
        $0.clipsToBounds = true
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        backgroundImageView.image = UIImage(named: "placeholder")
        matchScoreLabel.text = nil
        ballparkLabel.text = nil
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 30
        contentView.backgroundColor = .white
        contentView.addSubview(containerView)
        containerView.addSubview(backgroundImageView)
        containerView.addSubview(resultContainerView)
        containerView.addSubview(blurEffectView)
        resultContainerView.addSubview(resultLabel)
        blurEffectView.contentView.addSubview(labelsStackView)
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(5)
        }
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
        resultContainerView.snp.makeConstraints { make in
            make.top.leading
                .equalToSuperview()
                .inset(15)
        }
        
        resultLabel.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(6)
            make.top.bottom
                .equalToSuperview()
                .inset(4)
        }
        
        blurEffectView.snp.makeConstraints { make in
            make.leading.trailing.bottom
                .equalToSuperview()
            make.height
                .equalTo(70)
        }
        
        labelsStackView.snp.makeConstraints { make in
            make.top.leading.bottom
                .equalToSuperview()
                .inset(15)
        }
    }
}

extension DiaryCollectionViewCell {
    private func addShadow() {
        layer.masksToBounds = false
        layer.shadowColor   = UIColor.black.cgColor
        layer.shadowOffset  = CGSize(width: -2, height: 2)
        layer.shadowOpacity = 0.3
        layer.shadowRadius  = 5
    }
    
    public func configure(diary: Diary) {
        if let imageURLString = diary.imageURL, let imageURL = URL(string: imageURLString) {
            backgroundImageView.kf.setImage(with: imageURL)
        }
        matchScoreLabel.text = "\(diary.homeTeam) \(diary.homeScore) vs \(diary.awayScore) \(diary.awayTeam)"
        ballparkLabel.text = diary.ballpark
        
        switch diary.result {
        case "WIN":
            resultLabel.text = "승리"
            resultContainerView.backgroundColor = .tossBlueColor
        case "LOSS":
            resultLabel.text = "패배"
            resultContainerView.backgroundColor = .tossRedColor
        case "DRAW":
            resultLabel.text = "무승부"
            resultContainerView.backgroundColor = .mainCharcoalColor
        case "SCHEDULED":
            resultLabel.text = "경기예정"
            resultContainerView.backgroundColor = .mainCharcoalColor
        case "CANCELED":
            resultLabel.text = "경기취소"
            resultContainerView.backgroundColor = .mainCharcoalColor
        default:
            resultLabel.text = "-"
            resultContainerView.backgroundColor = .mainCharcoalColor
        }
    }
}
