//
//  TourBallparkSelectionView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import UIKit

final class TourBallparkSelectionView: UIView {
    
    private(set) var activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = UIColor.Custom.charcoal
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "어떤 구장을 방문하시나요?"
        $0.font = UIFont.pretendard(size: 22, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let subtitleLabel = UILabel().then {
        $0.text = "해당 구장 주변 핫플을 알려드릴게요"
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 0
    }
    
    // 구단 테이블 뷰
    private(set) var ballparkTableView = UITableView().then {
        $0.register(BallparkSelectionCell.self, forCellReuseIdentifier: BallparkSelectionCell.ID)
        $0.showsVerticalScrollIndicator = false
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
        self.addSubview(ballparkTableView)
        self.addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalTo(safeAreaLayoutGuide)
                .offset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(12)
            make.leading.trailing
                .equalTo(safeAreaLayoutGuide)
                .offset(20)
        }
        
        ballparkTableView.snp.makeConstraints { make in
            make.top
                .equalTo(subtitleLabel.snp.bottom)
                .offset(20)
            make.leading.trailing.bottom
                .equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
    }
}
