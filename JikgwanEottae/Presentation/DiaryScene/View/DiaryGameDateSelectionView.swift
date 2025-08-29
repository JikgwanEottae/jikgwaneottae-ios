//
//  RecordDateGameSelectionView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/26/25.
//

import UIKit

import SnapKit
import Then

final class DiaryGameDateSelectionView: UIView {
    // 액티비티 인티케이터
    public let activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = .mainCharcoalColor
    }
    
    // 사용자의 상호작용 블로커
    public let interactionBlocker = UIControl().then {
        $0.isHidden = true
    }
    
    // 스크롤 뷰
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    // 스택 뷰
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            titleLabel,
            subtitleLabel,
            datePicker,
            collectionView
        ]
    ).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 40
        $0.clipsToBounds = true
    }
    
    // 타이틀 레이블
    private let titleLabel = UILabel().then {
        $0.text = "직관한 날짜를 선택해주세요"
        $0.numberOfLines = 1
        $0.font = .gMarketSans(size: 20, family: .medium)
        $0.textColor = .primaryTextColor
    }
    
    // 서브 타이틀 레이블
    private let subtitleLabel = UILabel().then {
        $0.text = "날짜에 맞춰 경기 일정을 가져올게요"
        $0.numberOfLines = 1
        $0.font = .gMarketSans(size: 14, family: .medium)
        $0.textColor = .tertiaryTextColor
    }
    
    // 경기 날짜 선택 데이트 피커
    public let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
        $0.maximumDate = Date()
        $0.clipsToBounds = true
        $0.backgroundColor = .secondaryBackgroundColor
        $0.layer.cornerRadius = Constants.cornerRadius
    }
    
    // 경기 정보를 보여줄 컬렉션 뷰
    public lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).then {
        $0.register(
            KBOGameCollectionViewCell.self,
            forCellWithReuseIdentifier: KBOGameCollectionViewCell.ID
        )
        $0.showsHorizontalScrollIndicator = false
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
        addSubview(scrollView)
        addSubview(interactionBlocker)
        interactionBlocker.addSubview(activityIndicator)
        scrollView.addSubview(stackView)
    }
    
    private func setupUI() {
        self.backgroundColor = .white
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
        stackView.setCustomSpacing(12, after: titleLabel)
        datePicker.snp.makeConstraints { make in
            make.height
                .equalTo(250)
        }
        collectionView.snp.makeConstraints { make in
            make.height
                .equalTo(211)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY
                .equalToSuperview()
        }
        interactionBlocker.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
}

// MARK: - DiaryGameDateSelectionView Extension

extension DiaryGameDateSelectionView {
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(230),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 20
        return UICollectionViewCompositionalLayout(section: section)
    }
}
