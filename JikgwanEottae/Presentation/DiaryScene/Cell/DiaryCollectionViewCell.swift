//
//  DiaryCollectionViewCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/27/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class DiaryCollectionViewCell: UICollectionViewCell {

    static let ID = "DiaryCollectionViewCell"

    // 썸네일 이미지
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // 승패 결과 뱃지 컨테이너
    private let resultBadgeView = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5
    }

    // 승패 결과 레이블
    private let resultLabel = UILabel().then {
        $0.font = .pretendard(size: 14, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .white
        $0.clipsToBounds = true
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    private let blurEffectView = UIVisualEffectView().then {
        $0.effect =  UIBlurEffect(style: .systemThinMaterialDark)
    }

    private lazy var infoStackView = UIStackView(arrangedSubviews: [
        titleLabel,
        dateLabel
    ]).then {
        $0.axis = .vertical
        $0.distribution = .equalSpacing
        $0.alignment = .leading
     }

    // 일기 제목
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 14, family: .semiBold)
        $0.numberOfLines = 1
        $0.textColor = .white
        $0.textAlignment = .left
        $0.clipsToBounds = true
        $0.setContentHuggingPriority(.required, for: .vertical)
    }

    // 일기 작성 날짜
    private let dateLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 12, family: .regular)
        $0.numberOfLines = 1
        $0.textColor = .white.withAlphaComponent(0.8)
        $0.textAlignment = .left
        $0.clipsToBounds = true
        $0.setContentHuggingPriority(.required, for: .vertical)
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
        thumbnailImageView.image = UIImage(named: "placeholder")
        resultBadgeView.backgroundColor = nil
        resultLabel.text = nil
        titleLabel.text = nil
        dateLabel.text = nil
    }

    private func setupUI() {
        backgroundColor = .white
        contentView.clipsToBounds = true
        contentView.addSubview(thumbnailImageView)
        thumbnailImageView.addSubview(resultBadgeView)
        thumbnailImageView.addSubview(blurEffectView)
        resultBadgeView.addSubview(resultLabel)
        blurEffectView.contentView.addSubview(infoStackView)
    }

    private func setupLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }

        resultBadgeView.snp.makeConstraints { make in
            make.top.leading
                .equalToSuperview()
                .inset(8)
        }

        resultLabel.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(6)
            make.top.bottom
                .equalToSuperview()
                .inset(3)
        }

        blurEffectView.snp.makeConstraints { make in
            make.leading.trailing.bottom
                .equalToSuperview()
            make.height
                .equalTo(55)
        }

        infoStackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom
                .equalToSuperview()
                .inset(10)
        }
    }
}

// MARK: - Extension

extension DiaryCollectionViewCell {
    public func configure() {
        let randomIndex = Int.random(in: 1...9)
        let imageName = "test\(randomIndex)"
        thumbnailImageView.image = UIImage(named: imageName)
        
        resultBadgeView.backgroundColor = .tossBlueColor
        resultLabel.text = "승리"
        
        let titles = [
            "오늘의 승리요정",
            "야구장은 내 두 번째 집",
            "직관 운세 대폭발 🎉",
            "응원봉 들고 직관!",
            "비 오면 취소될까 걱정한 하루",
            "치킨과 맥주와 승리",
            "직관러의 하루 기록",
            "끝내기 안타의 짜릿함 ⚾️",
            "승리를 부르는 직관러"
        ]
        
        titleLabel.text = titles.randomElement()
        dateLabel.text = "2025년 11월 03일"
    }
}
