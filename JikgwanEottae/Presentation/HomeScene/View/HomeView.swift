//
//  HomeView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

import SnapKit
import Then

final class HomeView: UIView {
    
    // 현재 화면의 타이틀 레이블입니다.
    public let titleLabel = UILabel().then {
        $0.text = "직관어때"
        $0.font = UIFont.pretendard(size: 22, family: .bold)
        $0.textColor = UIColor.Text.primaryColor
        $0.numberOfLines = 1
    }
    
    public lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).then {
        $0.register(StatsCell.self, forCellWithReuseIdentifier: StatsCell.ID)
        $0.register(TodayGameCell.self, forCellWithReuseIdentifier: TodayGameCell.ID)
        $0.register(TodayFortuneCell.self, forCellWithReuseIdentifier: TodayFortuneCell.ID)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.contentInset = .init(top: 20, left: 0, bottom: 0, right: 0)
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
        self.addSubview(collectionView)
        self.backgroundColor = .white
    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.top.bottom
                .equalToSuperview()
            make.leading.trailing
                .equalToSuperview()
                .inset(15)
        }
    }
}

extension HomeView {
    /// 컬렉션뷰에서 사용할 섹션에 따라 레이아웃을 생성합니다.
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            let section = HomeSection.allCases[sectionIndex]
            switch section {
            case .stats:
                return self?.createStatsSection()
            case .todayGames:
                return self?.createTodayGamesSection()
            case .todayFortune:
                return self?.createTodayFortuneSection()
            }
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 15
        layout.configuration = config
        // 섹션의 배경을 등록합니다.
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.kind)
        return layout
    }
    /// 직관 승률을 보여주기 위한 통계 섹션의 레이아웃을 생성합니다.
    private func createStatsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(200)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    /// 오늘의 야구 경기 일정보기 섹션의 레이아웃을 생성합니다.
    private func createTodayGamesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.6),
            heightDimension: .absolute(150)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        section.orthogonalScrollingBehavior = .groupPaging
        return section
    }
    
    /// 오늘의 직관 운세보기 섹션의 레이아웃을 생성합니다.
    private func createTodayFortuneSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}
