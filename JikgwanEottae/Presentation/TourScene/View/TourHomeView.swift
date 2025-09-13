//
//  TourHomeView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/29/25.
//

import UIKit

import SnapKit
import Then

final class TourHomeView: UIView {
    // 왼쪽 바 버튼 아이템 타이틀 레이블입니다.
    public let leftBarButtonTitleLabel = UILabel().then {
        $0.text = "지도"
        $0.numberOfLines = 1
        $0.font = UIFont.gMarketSans(size: 24, family: .bold)
        $0.textColor = .black
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            titleInfoLabel,
            subTitleInfoLabel,
            collectionView
        ]
    ).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 40
        $0.clipsToBounds = true
    }
    
    // 타이틀 인포 레이블입니다.
    private let titleInfoLabel = UILabel().then {
        $0.text = "직관과 여행을 한번에"
        $0.numberOfLines = 1
        $0.font = .gMarketSans(size: 20, family: .medium)
        $0.textColor = .primaryTextColor
    }
    
    // 서브타이틀 인포 레이블입니다.
    private let subTitleInfoLabel = UILabel().then {
        $0.text = "구단 경기장 주변 관광 명소를 찾아드릴게요"
        $0.numberOfLines = 1
        $0.font = .gMarketSans(size: 14, family: .medium)
        $0.textColor = .tertiaryTextColor
    }
    
    // 구단을 보여줄 컬렉션 뷰입니다.
    public lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).then {
        $0.register(
            TeamSelectionCell.self,
            forCellWithReuseIdentifier: TeamSelectionCell.ID
        )
        $0.showsHorizontalScrollIndicator = false
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
        [scrollView].forEach { self.addSubview($0) }
        scrollView.addSubview(stackView)
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        stackView.snp.makeConstraints { make in
            make.edges
                .equalTo(scrollView.contentLayoutGuide)
            make.width
                .equalTo(scrollView.frameLayoutGuide)
        }
        stackView.setCustomSpacing(12, after: titleInfoLabel)
        collectionView.snp.makeConstraints { make in
            make.height
                .equalTo(560)
        }
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(15)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        return UICollectionViewCompositionalLayout(section: section)
    }
}
