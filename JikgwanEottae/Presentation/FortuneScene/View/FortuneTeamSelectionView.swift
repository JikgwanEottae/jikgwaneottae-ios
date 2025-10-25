//
//  FortuneTeamSelectionView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/10/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 오늘의 직관 운세를 확인하기 위한 응원 구단 선택 뷰입니다.

final class FortuneTeamSelectionView: UIView {
    // 진행 상태 프로그레스 뷰
    private(set) var progressView = UIProgressView(progressViewStyle: .default).then {
        $0.progressTintColor = UIColor.Custom.blue
        $0.trackTintColor = UIColor.Background.primaryColor
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
        $0.setProgress(0.0, animated: false)
    }
    
    // 타이틀 레이블
    private let titleLabel = UILabel().then {
        $0.text = "어떤 구단을 응원하시나요?"
        $0.font = UIFont.pretendard(size: 22, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    // 구단 테이블 뷰
    private(set) var teamTableView = UITableView().then {
        $0.register(TeamTableViewCell.self, forCellReuseIdentifier: TeamTableViewCell.ID)
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
        self.addSubview(progressView)
        self.addSubview(titleLabel)
        self.addSubview(teamTableView)
    }
    
    private func setupLayout() {
        progressView.snp.makeConstraints { make in
            make.top
                .equalTo(safeAreaLayoutGuide)
                .offset(20)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.height
                .equalTo(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top
                .equalTo(progressView.snp.bottom)
                .offset(40)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        teamTableView.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(40)
            make.leading.trailing.bottom
                .equalToSuperview()
        }
    }
}
