//
//  TodayFortuneResultView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/2/25.
//

import UIKit

import SnapKit
import Then

final class TodayFortuneResultView: UIView {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private lazy var stackView = UIStackView(arrangedSubviews: [
        dateLabel,
        imageView,
        innerStackView,
        recommendationLabel
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 40
        $0.clipsToBounds = true
    }
    
    private let imageView = UIImageView().then {
        $0.image = UIImage(named: "fairy")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "9월 3일 수요일"
        $0.numberOfLines = 1
        $0.font = .gMarketSans(size: 17, family: .medium)
        $0.textColor = .primaryTextColor
        $0.textAlignment = .center
    }
    
    private lazy var innerStackView = UIStackView(arrangedSubviews: [
        scoreLabel,
        fortuneDescLabel
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 30, left: 20, bottom: 30, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .center
        $0.spacing = 30
        $0.clipsToBounds = true
        $0.backgroundColor = .secondaryBackgroundColor
        $0.layer.cornerRadius = Constants.cornerRadius
    }
    
    private let scoreLabel = UILabel().then {
        $0.text = "73점"
        $0.numberOfLines = 1
        $0.font = .gMarketSans(size: 25, family: .bold)
        $0.textColor = .secondaryTextColor
        $0.textAlignment = .center
    }
    
    private let fortuneDescLabel = UILabel().then {
        $0.text = "오늘의 오행은 安! 안정적인 경기 운영이 예상됩니다!\n\n십신 관계가 보통 수준으로 팀과의 관계를 개선할 여지가 있습니다.\n오늘은 응원의 힘이 더욱 필요한 날입니다. 끝까지 함께해주세요!"
        $0.setLineSpacing(spacing: 8)
        $0.numberOfLines = 0
        $0.font = .gMarketSans(size: 17, family: .medium)
        $0.textColor = .secondaryTextColor
        $0.textAlignment = .center
    }
    
    private let recommendationLabel = UILabel().then {
        $0.text = "오늘 경기에서 삼성 라이온즈의 승리를 기원하며 응원해주세요!"
        $0.setLineSpacing(spacing: 8)
        $0.numberOfLines = 0
        $0.font = .gMarketSans(size: 15, family: .medium)
        $0.textColor = .secondaryTextColor
        $0.textAlignment = .center
    }
    
    private(set) var completeButton = UIButton(type: .custom).then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .gMarketSans(size: 18, family: .medium)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainCharcoalColor
        $0.layer.cornerRadius = 17
        $0.clipsToBounds = true
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
    
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(scrollView)
        self.addSubview(completeButton)
        self.scrollView.addSubview(stackView)
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalTo(safeAreaLayoutGuide)
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
        imageView.snp.makeConstraints { make in
            make.height
                .equalTo(200)
        }
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.bottom
                .equalTo(safeAreaLayoutGuide)
                .inset(20)
            make.height
                .equalTo(Constants.buttonHeight)
        }
    }

}
