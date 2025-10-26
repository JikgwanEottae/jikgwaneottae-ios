//
//  TourNearByPlaceView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import UIKit

import SnapKit
import Then

final class TourNearByPlaceView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "핫플레이스 Top 50"
        $0.font = UIFont.pretendard(size: 22, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "* 24년 8월 ~ 25년 9월을 기준으로 가장 연관성이 높은 주변 관광지"
        $0.font = UIFont.pretendard(size: 12, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.setLineSpacing(spacing: 2)
        $0.lineBreakStrategy = .hangulWordPriority
        $0.numberOfLines = 0
    }
    
    private(set) var attractionTableView = UITableView().then {
        $0.register(AttractionCell.self, forCellReuseIdentifier: AttractionCell.ID)
        $0.showsVerticalScrollIndicator = true
        $0.alwaysBounceVertical = true
        $0.rowHeight = 70
        $0.separatorStyle = .none
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
        backgroundColor = UIColor.white
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(attractionTableView)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top
                .equalTo(safeAreaLayoutGuide)
                .offset(20)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(12)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        attractionTableView.snp.makeConstraints { make in
            make.top
                .equalTo(subtitleLabel.snp.bottom)
                .offset(20)
            make.leading.trailing.bottom
                .equalToSuperview()
        }
    }
}
