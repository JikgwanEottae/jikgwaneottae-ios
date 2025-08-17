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
        $0.text = "직관어때?"
        $0.numberOfLines = 1
        $0.font = UIFont.kbo(size: 25, family: .bold)
        $0.textColor = .black
    }
    
    public lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).then {
        $0.register(TeamTourCell.self, forCellWithReuseIdentifier: TeamTourCell.ID)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = true
        $0.contentInset = .init(top: 30, left: 0, bottom: 0, right: 0)
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
    
    private func addSubviews() {
        addSubview(collectionView)
    }

    private func setupUI() {
        self.backgroundColor = .white
    }
    
    private func setupLayout() {
        
        collectionView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }


}

extension HomeView {
    /// 컬렉션뷰에서 사용할 섹션에 따라 레이아웃을 생성합니다.
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            let section = HomeSection.allCases[sectionIndex]
            switch section {
            case .tour:
                return self?.createTourSection()
            }
        }
        
        // 섹션의 배경을 등록합니다.
        layout.register(SectionBackgroundDecorationView.self, forDecorationViewOfKind: SectionBackgroundDecorationView.kind)
        
        return layout
    }
    
    /// 관광 섹션에서 사용할 레이아웃을 생성합니다.
    private func createTourSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 5.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(100)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item]
        )
        // 그룹 내 아이템 간격을 설정합니다.
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        
        // 섹션 내 그룹 간격을 설정합니다.
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 15, bottom: 15, trailing: 15)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: SectionTitleHeaderView.elementKind,
            alignment: .top
        )
        
        // 헤더에 inset을 부여합니다.
        header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        
        let footerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(10)
        )
        let footer = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: footerSize,
            elementKind: SectionSeparatorView.elementKind,
            alignment: .bottom
        )
        
        // SupplementaryView의 inset을 섹션과 맞추지 않기로 설정합니다.
        section.supplementariesFollowContentInsets = false
        
        // 섹션에 SupplementaryView를 등록합니다.
        section.boundarySupplementaryItems = [header, footer]
        return section
    }
}
