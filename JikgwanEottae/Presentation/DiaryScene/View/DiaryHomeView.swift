//
//  DiaryHomeView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/25/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 직관 일기 홈 뷰입니다.

final class DiaryHomeView: UIView {
    
    public let titleLabel = UILabel().then {
        $0.text = "일기"
        $0.font = UIFont.pretendard(size: 24, family: .bold)
        $0.textColor = UIColor.Text.primaryColor
        $0.numberOfLines = 1
    }
    
    private(set) var sortButton = UIBarButtonItem().then {
        let config = UIImage.SymbolConfiguration(pointSize: 13, weight: .semibold)
        $0.image = UIImage(systemName: "arrow.up.arrow.down", withConfiguration: config)
        $0.style = .plain
    }
    
    private(set) var plusButton = UIBarButtonItem().then {
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        $0.image = UIImage(systemName: "plus", withConfiguration: config)
        $0.style = .plain
    }

    private(set) lazy var allButton = makeFilterButton(title: "전체")
    private(set) lazy var winButton = makeFilterButton(title: "승리")
    private(set) lazy var lossButton = makeFilterButton(title: "패배")
    private(set) lazy var drawButton = makeFilterButton(title: "무승부")
    
    private let selectionFeedback = UISelectionFeedbackGenerator()

    // MARK: - UI Components
    private let filterView = UIView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = true
    }

    // 컬렉션 뷰
    public private(set) lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: createLayout()
    ).then {
        $0.backgroundColor = .white
        $0.register(DiaryCollectionViewCell.self,
                    forCellWithReuseIdentifier: DiaryCollectionViewCell.ID)
        $0.register(DiarySectionHeaderView.self,
                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                    withReuseIdentifier: DiarySectionHeaderView.ID)
    }
    
    public let activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = UIColor.Custom.charcoal
    }

    // MARK: - 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        selectFilterButton(allButton)
        selectionFeedback.prepare()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        self.backgroundColor = UIColor.white
        addSubview(filterView)
        addSubview(activityIndicator)
        addSubview(collectionView)
        [allButton, winButton, lossButton, drawButton].forEach {
            filterView.addSubview($0)
        }
    }

    private func setupLayout() {
        filterView.snp.makeConstraints {
            $0.top
                .equalTo(safeAreaLayoutGuide)
            $0.leading.trailing
                .equalToSuperview()
            $0.height
                .equalTo(55)
        }
        
        allButton.snp.makeConstraints { make in
            make.centerY
                .equalToSuperview()
            make.leading.top.bottom
                .equalToSuperview()
                .inset(8)
        }
        
        winButton.snp.makeConstraints { make in
            make.centerY
                .equalToSuperview()
            make.leading
                .equalTo(allButton.snp.trailing)
                .offset(5)
            make.top.bottom
                .equalToSuperview()
                .inset(8)
        }
        
        lossButton.snp.makeConstraints { make in
            make.centerY
                .equalToSuperview()
            make.leading
                .equalTo(winButton.snp.trailing)
                .offset(5)
            make.top.bottom
                .equalToSuperview()
                .inset(8)
        }
        
        drawButton.snp.makeConstraints { make in
            make.centerY
                .equalToSuperview()
            make.leading
                .equalTo(lossButton.snp.trailing)
                .offset(5)
            make.top.bottom
                .equalToSuperview()
                .inset(8)
        }

        collectionView.snp.makeConstraints {
            $0.top
                .equalTo(filterView.snp.bottom)
            $0.leading.trailing.bottom
                .equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
    }
}

extension DiaryHomeView {
    /// 필터 버튼을 생성합니다.
    private func makeFilterButton(title: String) -> UIButton {
        return UIButton(type: .custom).then {
            $0.setTitle(title, for: .normal)
            $0.setTitleColor(UIColor.Text.primaryColor, for: .normal)
            $0.titleLabel?.font = UIFont.pretendard(size: 16, family: .medium)
            $0.contentEdgeInsets = UIEdgeInsets(top: 12, left: 14, bottom: 12, right: 14)
            $0.backgroundColor = UIColor.Background.primaryColor
            $0.layer.borderColor = UIColor.Background.borderColor.cgColor
            $0.layer.cornerRadius = 12
            $0.layer.borderWidth = 1
            $0.clipsToBounds = true
        }
    }
    
    /// 필터 버튼을 선택으로 활성화합니다.
    public func selectFilterButton(_ selectedButton: UIButton) {
        [allButton, winButton, lossButton, drawButton].forEach { button in
            let isSelected = (button == selectedButton)
            button.backgroundColor = isSelected ? UIColor.Background.primaryColor : UIColor.white
            button.setTitleColor(isSelected ? UIColor.Text.primaryColor : UIColor.Text.secondaryColor, for: .normal)
            button.layer.borderColor = isSelected ? UIColor.Background.primaryColor.cgColor : UIColor.white.cgColor
        }
        selectionFeedback.selectionChanged()
    }
}

extension DiaryHomeView {
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
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
        group.interItemSpacing = .fixed(5)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        section.contentInsets = .init(top: 0, leading: 8, bottom: 8, trailing: 8)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(35)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
