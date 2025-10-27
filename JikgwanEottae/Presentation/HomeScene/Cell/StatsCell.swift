//
//  StatsCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/1/25.
//

import UIKit

import Then
import SnapKit

// MARK: - 직관 승률을 보여주기 위한 커스텀 컬렉션 뷰 셀입니다.

final class StatsCell: UICollectionViewCell {
    static let ID = "StatsCell"
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 16, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        $0.setContentHuggingPriority(.required, for: .vertical)
    }
    
    private lazy var statsStackView = UIStackView(arrangedSubviews: [
        winStatsItem,
        lossStatsItem,
        drawStatsItem
    ]).then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    private let winStatsItem = StatsItemView(title: "승리", count: 0)
    private let firstDivideView = UIView().then { $0.backgroundColor = UIColor.Background.borderColor }
    private let lossStatsItem = StatsItemView(title: "패배", count: 0)
    private let secondDivideView = UIView().then { $0.backgroundColor = UIColor.Background.borderColor }
    private let drawStatsItem = StatsItemView(title: "무승부", count: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    private func setupUI() {
        self.layer.cornerRadius = Constants.cornerRadius
        self.backgroundColor = .secondaryBackgroundColor
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(statsStackView)
        self.contentView.addSubview(firstDivideView)
        self.contentView.addSubview(secondDivideView)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalToSuperview()
        }
        
        statsStackView.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(30)
            make.leading.trailing.bottom
                .equalToSuperview()
        }
        
        firstDivideView.snp.makeConstraints { make in
            make.top.bottom
                .equalTo(winStatsItem)
            make.leading
                .equalTo(winStatsItem.snp.trailing)
            make.width
                .equalTo(1)
        }
        
        secondDivideView.snp.makeConstraints { make in
            make.top.bottom
                .equalTo(lossStatsItem)
            make.leading
                .equalTo(lossStatsItem.snp.trailing)
            make.width
                .equalTo(1)
        }
    }
    
    public func configure(stats: DiaryStats) {
        titleLabel.text = "나의 직관 승률 \(Int(stats.winRate))%"
        winStatsItem.configure(count: stats.wins)
        lossStatsItem.configure(count: stats.losses)
        drawStatsItem.configure(count: stats.draws)
    }
}

extension StatsCell {
    final class StatsItemView: UIView {
        private let titleLabel = UILabel().then {
            $0.font = UIFont.pretendard(size: 16, family: .medium)
            $0.textColor = UIColor.Text.primaryColor
            $0.textAlignment = .center
        }
        
        private let countLabel = UILabel().then {
            $0.font = UIFont.pretendard(size: 18, family: .semiBold)
            $0.textColor = UIColor.Text.primaryColor
            $0.textAlignment = .center
        }
        
        private lazy var stackView = UIStackView(arrangedSubviews: [
            titleLabel,
            countLabel
        ]).then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
        
        init(title: String, count: Int) {
            titleLabel.text = title
            countLabel.text = "\(count)"
            super.init(frame: .zero)
            self.addSubview(stackView)
            stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public func configure(count: Int) {
            countLabel.text = "\(count)"
        }
    }
}
