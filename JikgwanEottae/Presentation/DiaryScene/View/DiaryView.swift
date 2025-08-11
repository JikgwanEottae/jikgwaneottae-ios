//
//  RecordView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/22/25.
//

import UIKit

import FSCalendar
import SnapKit
import Then

final class DiaryView: UIView {

    // MARK: - Property
    
    // 네비게이션 타이틀 레이블
    public let titleLabel = UILabel().then {
        $0.text = "기록"
        $0.numberOfLines = 1
        $0.font = UIFont.kbo(size: 25, family: .bold)
        $0.textColor = .black
    }
    // 스크롤 뷰
    private let scrollView = UIScrollView().then {
        $0.clipsToBounds = true
        $0.alwaysBounceVertical = true
    }
    // 스택 뷰
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            fscalendarView,
            selectedDateContainerView,
            collectionView
        ]
    ).then {
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(top: 11, left: 11, bottom: 0, right: 11)
        $0.spacing = 15
        $0.clipsToBounds = true
    }
    // 캘린더 뷰
    public let fscalendarView = FSCalendar().then {
        // 커스텀 셀 등록
        $0.register(CustomFSCalendarCell.self, forCellReuseIdentifier: CustomFSCalendarCell.ID)
        $0.locale = Locale(identifier: "ko_KR")
        // 년월 헤더 높이
        $0.headerHeight = 0
        // 요일 텍스트 색상
        $0.appearance.weekdayTextColor = .tertiaryTextColor
        // 요일 폰트 설정
        $0.appearance.weekdayFont = .gMarketSans(size: 14, family: .medium)
        // 날짜 폰트 설정
        $0.appearance.titleFont = .gMarketSans(size: 14, family: .medium)
        // 해당 월이 아닌 날짜 표시 여부
        $0.placeholderType = .none
        // 해당 월의 날짜 색상
        $0.appearance.titleDefaultColor = .primaryTextColor
        // 오늘 날짜 원 색상
        $0.appearance.todayColor = .calendarSelectionColor
        // 오늘 날짜 텍스트 색상
        $0.appearance.titleTodayColor = .white
        // 선택된 날짜 원 색상
        $0.appearance.selectionColor = .calendarSelectionColor
        // 선택된 날짜 텍스트 색상
        $0.appearance.titleSelectionColor = .white
        $0.appearance.subtitleOffset = CGPoint(x: 0, y: 15)
        $0.appearance.eventDefaultColor = .tossRedColor
        $0.appearance.eventSelectionColor = .tossRedColor
    }
    // 캘린더 아래 구분선 표시를 위한 뷰
    private let fscalendarBottomLineView = UIView().then {
        $0.backgroundColor = .systemGray6
    }
    // 선택된 날짜 레이블 컨테이너 뷰
    private let selectedDateContainerView = UIView()
    // 선택된 날짜 표시 레이블
    public let selectedDateLabel = UILabel().then {
        $0.text = Date().toFormattedString("d. E")
//        $0.font = .pretendard(size: 20, family: .semiBold)
        $0.font = .gMarketSans(size: 20, family: .medium)
        $0.textColor = .primaryTextColor
        $0.numberOfLines = 1
    }
    
    // 작성된 직관 일기를 보여줄 컬렉션 뷰
    public lazy var collectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeLayout()
    ).then {
        $0.register(
            DiaryCollectionViewCell.self,
            forCellWithReuseIdentifier: DiaryCollectionViewCell.ID
        )
        $0.showsHorizontalScrollIndicator = false
    }
    
    // 직관 기록을 생성하기 위한 플로팅 버튼
    public let createDiaryButton = UIButton(type: .custom).then {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 23, weight: .medium)
        $0.setImage(UIImage(systemName: "plus", withConfiguration: imageConfig), for: .normal)
        $0.backgroundColor = .mainCharcoalColor
        $0.tintColor = .white
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowRadius = 6
        $0.layer.cornerRadius = 28
        $0.adjustsImageWhenHighlighted = false
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        self.addSubview(scrollView)
        self.addSubview(createDiaryButton)
        self.scrollView.addSubview(stackView)
        self.selectedDateContainerView.addSubview(selectedDateLabel)
        self.scrollView.addSubview(fscalendarBottomLineView)
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
        fscalendarView.snp.makeConstraints { make in
            make.height
                .equalTo(380)
        }
        selectedDateLabel.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            )
        }
        fscalendarBottomLineView.snp.makeConstraints { make in
            make.left.right
                .equalToSuperview()
            make.top
                .equalTo(fscalendarView.snp.bottom)
            make.height
                .equalTo(1)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height
                .equalTo(400)
        }
        
        createDiaryButton.snp.makeConstraints { make in
            make.width.height
                .equalTo(56)
            make.trailing.bottom
                .equalTo(safeAreaLayoutGuide)
                .inset(20)
        }
    }
    
    private func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(260),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: itemSize,
            subitems: [item]
        )
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 30
        return UICollectionViewCompositionalLayout(section: section)
    }
}
