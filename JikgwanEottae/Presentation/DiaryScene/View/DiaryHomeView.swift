//
//  DiaryHomeView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/25/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 직관 일기 홈 커스텀 뷰입니다.

final class DiaryHomeView: UIView {
    // 네비게이션 타이틀 레이블
    public let titleLabel = UILabel().then {
        $0.text = "일기"
        $0.numberOfLines = 1
        $0.font = UIFont.pretendard(size: 26, family: .bold)
        $0.textColor = UIColor.Text.secondaryColor
    }
    
    private(set) lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.backgroundColor = .white
        $0.register(
            DiaryCollectionViewCell.self,
            forCellWithReuseIdentifier: DiaryCollectionViewCell.ID
        )
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

    }
    
    private func setupLayout() {
        collectionView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
}

extension DiaryHomeView {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 2.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(300)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 2
        )
        // 그룹 내부 아이템 간 간격을 설정합니다.
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(2)
        let section = NSCollectionLayoutSection(group: group)
        // 섹션 내부 그룹 간 간격을 설정합니다.
        section.interGroupSpacing = 2
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 0,
            bottom: 0,
            trailing: 0
        )
        return UICollectionViewCompositionalLayout(section: section)
    }
}
