//
//  FortuneResultView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/2/25.
//

import UIKit

import SnapKit
import Then

final class FortuneResultView: UIView {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        dateLabel,
        imageView,
        recommendationLabel,
        innerStackView,
        noteContainerView
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 10, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 40
        $0.clipsToBounds = true
    }
    
    private(set) var dateLabel = UILabel().then {
        $0.text = Date().toFormattedString("M월 dd일 EEEE")
        $0.font = UIFont.pretendard(size: 18, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.setLineSpacing(spacing: 5)
        $0.numberOfLines = 2
        $0.textAlignment = .center
    }
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let recommendationLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 14, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    private lazy var innerStackView = UIStackView(arrangedSubviews: [
        scoreContainerView,
        compatibilityContainerView,
        descContainerView
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 25, left: 20, bottom: 25, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 30
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.Background.secondaryColor
        $0.layer.cornerRadius = 20
    }
    
    private let scoreContainerView = UIView().then {
        $0.backgroundColor = UIColor.Background.secondaryColor
        $0.clipsToBounds = true
    }
    
    private let scoreTitleLabel = UILabel().then {
        $0.text = "직관 운세 점수는"
        $0.font = UIFont.pretendard(size: 16, family: .semiBold)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private(set) var scoreValueLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 20, family: .bold)
        $0.textColor = UIColor.Custom.blue
        $0.textAlignment = .right
        $0.numberOfLines = 1
    }
    
    private let compatibilityContainerView = UIView().then {
        $0.backgroundColor = UIColor.Background.secondaryColor
        $0.clipsToBounds = true
    }
    
    private let compatibilityTitleLabel = UILabel().then {
        $0.text = "구단과의 궁합은"
        $0.font = UIFont.pretendard(size: 16, family: .semiBold)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private(set) var compatibilityValueLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 20, family: .bold)
        $0.textColor = UIColor.Custom.blue
        $0.textAlignment = .right
        $0.numberOfLines = 1
    }
    
    private let descContainerView = UIView().then {
        $0.backgroundColor = UIColor.Background.secondaryColor
        $0.clipsToBounds = true
    }
    
    private let descTitleLabel = UILabel().then {
        $0.text = "운세 해석"
        $0.font = UIFont.pretendard(size: 14, family: .semiBold)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private(set) var descValueLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 16, family: .semiBold)
        $0.textColor = UIColor.Text.secondaryColor
        $0.lineBreakStrategy = .hangulWordPriority
        $0.numberOfLines = 0
    }
    
    private let noteContainerView = UIView().then {
        $0.clipsToBounds = true
    }
    
    private let noteLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 12, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 0
        $0.isHidden = true
    }
    
    private(set) var completeButton = UIButton(type: .custom).then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(size: 18, family: .semiBold)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor.Custom.blue
        $0.layer.cornerRadius = 17
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(scrollView)
        self.addSubview(completeButton)
        self.scrollView.addSubview(stackView)
        
        [scoreTitleLabel, scoreValueLabel].forEach {
            scoreContainerView.addSubview($0)
        }
        
        [compatibilityTitleLabel, compatibilityValueLabel].forEach {
            compatibilityContainerView.addSubview($0)
        }
        
        [descTitleLabel, descValueLabel].forEach {
            descContainerView.addSubview($0)
        }
        
        noteContainerView.addSubview(noteLabel)
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalToSuperview()
            make.bottom
                .equalTo(completeButton.snp.top)
                .offset(-10)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges
                .equalTo(scrollView.contentLayoutGuide)
            make.width
                .equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.setCustomSpacing(30, after: recommendationLabel)
        stackView.setCustomSpacing(10, after: innerStackView)
        
        imageView.snp.makeConstraints { make in
            make.height
                .equalTo(250)
        }
        
        scoreTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom
                .equalToSuperview()
        }
        
        scoreValueLabel.snp.makeConstraints { make in
            make.trailing.top.bottom
                .equalToSuperview()
        }
        
        compatibilityTitleLabel.snp.makeConstraints { make in
            make.leading.top.bottom
                .equalToSuperview()
        }
        
        compatibilityValueLabel.snp.makeConstraints { make in
            make.trailing.top.bottom
                .equalToSuperview()
        }
        
        descTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalToSuperview()
        }
        
        descValueLabel.snp.makeConstraints { make in
            make.top
                .equalTo(descTitleLabel.snp.bottom)
                .offset(5)
            make.leading.trailing.bottom
                .equalToSuperview()
        }
        
        noteLabel.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(10)
            make.top.bottom
                .equalToSuperview()
        }
        
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing
                .equalTo(safeAreaLayoutGuide)
                .inset(20)
            make.bottom
                .equalTo(safeAreaLayoutGuide)
                .inset(10)
            make.height
                .equalTo(Constants.Button.height)
        }
    }
}

extension FortuneResultView {
    public func configure(with fortune: Fortune) {
        configureImage()
        configureRecommendation(fortune.recommendation)
        configureScore(fortune.score)
        configureCompatibility(fortune.compatibility)
        configureDescription(fortune.description)
        configureNoteIfNeeded(fortune.note)
    }
}

private extension FortuneResultView {
    /// 점수 / 운세 테마 캐릭터 이미지를 랜덤 선택
    private func configureImage() {
        let images = ["bear", "bunny", "cat"]
        imageView.image = UIImage(named: images.randomElement() ?? "bear")
    }
    
    /// 추천 응원 문구
    private func configureRecommendation(_ text: String) {
        recommendationLabel.text = text
    }
    
    /// 점수 표시
    private func configureScore(_ score: Double) {
        scoreValueLabel.text = "\(Int(score))점"
    }
    
    /// 궁합 등급
    private func configureCompatibility(_ compatibility: String) {
        compatibilityValueLabel.text = "\(compatibility)등급"
    }
    
    /// 운세 해설 본문
    private func configureDescription(_ text: String) {
        descValueLabel.text = text
        descValueLabel.setLineSpacing(spacing: 5)
    }
    
    /// 출생 시간 미기입 안내 문구
    private func configureNoteIfNeeded(_ note: String) {
        guard !note.isEmpty else { return }
        noteLabel.isHidden = false
        noteLabel.text = note
        noteLabel.setLineSpacing(spacing: 3)
    }
}
