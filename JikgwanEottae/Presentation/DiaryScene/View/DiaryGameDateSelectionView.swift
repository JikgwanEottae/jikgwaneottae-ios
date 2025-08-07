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
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private lazy var stackView = UIStackView(
        arrangedSubviews:[
            titleLabel,
            subtitleLabel,
            datePicker,
            tableView
        ]
    ).then {
        $0.layoutMargins = UIEdgeInsets(
            top: 20,
            left: 20,
            bottom: 20,
            right: 20
        )
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 50
        $0.clipsToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "직관한 날짜를 선택해주세요"
        $0.numberOfLines = 1
//        $0.font = .pretendard(size: 23, family: .semiBold)
        $0.font = .gMarketSans(size: 22, family: .medium)
        $0.textColor = .primaryTextColor
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "날짜에 맞춰 경기 일정을 가져올게요"
        $0.numberOfLines = 1
//        $0.font = .pretendard(size: 16, family: .medium)
        $0.font = .gMarketSans(size: 15, family: .medium)
        $0.textColor = .tertiaryTextColor
    }
    
    public let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
        $0.maximumDate = Date()
        $0.clipsToBounds = true
        $0.backgroundColor = .secondaryBackgroundColor
        $0.layer.cornerRadius = Constants.cornerRadius
    }
    // 테이블 뷰 높이 제약
    private var tableViewHeightConstraint: Constraint?
    
    // 테이블 뷰
    public let tableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(KBOGameTableViewCell.self, forCellReuseIdentifier: KBOGameTableViewCell.ID)
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.rowHeight = 110
        $0.separatorStyle = .none
    }
    
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
            make.top.leading.trailing.bottom
                .equalToSuperview()
        }
        stackView.setCustomSpacing(10, after: titleLabel)
        stackView.snp.makeConstraints { make in
            make.edges
                .equalTo(scrollView.contentLayoutGuide)
            make.width
                .equalTo(scrollView.frameLayoutGuide)
        }
        datePicker.snp.makeConstraints { make in
            make.height
                .equalTo(270)
        }
        tableView.snp.makeConstraints { make in
            tableViewHeightConstraint = make.height
                .equalTo(110).constraint
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY
                .equalToSuperview()
        }
        interactionBlocker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    public func updateTableViewHeight(to height: CGFloat) {
        tableViewHeightConstraint?.update(offset: height)
    }
}
