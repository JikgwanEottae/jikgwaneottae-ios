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

final class RecordView: UIView {

    // MARK: - Property
    
    // 네비게이션 타이틀 레이블
    public let titleLabel = UILabel().then {
        $0.text = "기록"
        $0.numberOfLines = 1
        $0.font = UIFont.kbo(size: 25, family: .bold)
        $0.textColor = .black
    }
    
    private let scrollView = UIScrollView().then {
        $0.clipsToBounds = true
    }
    
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            fscalendarView,
            dateContainerView,
            view
        ]
    ).then {
        $0.axis = .vertical
        $0.isLayoutMarginsRelativeArrangement = true
        $0.layoutMargins = UIEdgeInsets(
            top: 11,
            left: 11,
            bottom: 0,
            right: 11
        )
        $0.spacing = Constants.Layout.spacing
        $0.clipsToBounds = true
    }
    
    public let fscalendarView = FSCalendar().then {
        $0.locale = Locale(identifier: "ko_KR")
        // 년월 헤더 높이
        $0.headerHeight = 0
        // 요일 텍스트 색상
        $0.appearance.weekdayTextColor = .tertiaryTextColor
        // 요일 폰트 설정
        $0.appearance.weekdayFont = .pretendard(size: 14, family: .medium)
        // 날짜 폰트 설정
        $0.appearance.titleFont = .pretendard(size: 14, family: .medium)
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
    }
    
    private let dateContainerView = UIView()
    
    public let dateLabel = UILabel().then {
        $0.text = Date().toFormattedString("d. E")
        $0.font = .pretendard(size: 20, family: .semiBold)
        $0.textColor = .primaryTextColor
        $0.numberOfLines = 1
    }
    
    public let view = UIView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 15
        $0.backgroundColor = .backgroundColor
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
        self.scrollView.addSubview(stackView)
        self.dateContainerView.addSubview(dateLabel)
    }
    
    // MARK: - UI
    
    private func setupUI() {
        self.backgroundColor = .white
    }
    
    // MARK: - Layout
    
    private func setupLayout() {
        self.scrollView.snp.makeConstraints {
            make in
            make.edges.equalToSuperview()
        }
        
        self.stackView.snp.makeConstraints {
            make in
            make.edges.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(scrollView.frameLayoutGuide)
        }
        
        self.fscalendarView.snp.makeConstraints {
            make in
            make.height
                .equalTo(380)
        }
        
        self.dateLabel.snp.makeConstraints {
            make in
            make.edges.equalToSuperview().inset(
                UIEdgeInsets(
                    top: 0,
                    left: 5,
                    bottom: 0,
                    right: 10
                )
            )
        }
        
        self.view.snp.makeConstraints {
            make in
            make.height
                .equalTo(700)
        }
        
    }

}
