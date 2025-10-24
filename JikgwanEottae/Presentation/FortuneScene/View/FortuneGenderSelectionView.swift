//
//  FortuneGenderSelectionView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/10/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 오늘의 직관 운세를 확인하기 위한 성별 선택 뷰입니다.

final class FortuneGenderSelectionView: UIView {
    // 진행 상태 프로그레스 뷰
    public var progressView = UIProgressView(progressViewStyle: .default).then {
        $0.progressTintColor = UIColor.Custom.orange
        $0.trackTintColor = UIColor.Background.primaryColor
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
        $0.setProgress(0.3, animated: false)
    }
    
    // 타이틀 레이블
    private let titleLabel = UILabel().then {
        $0.text = "성별을 선택해주세요"
        $0.font = UIFont.pretendard(size: 22, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    // 성별 수평 스택뷰
    private lazy var genderStackView = UIStackView(
        arrangedSubviews: [maleButton, femaleButton]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private(set) var maleButton = UIButton(type: .system).then {
        $0.setTitle("남성", for: .normal)
        $0.setTitleColor(UIColor.Text.secondaryColor, for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(size: 18, family: .medium)
        $0.backgroundColor = UIColor.Background.secondaryColor
        $0.layer.cornerRadius = Constants.Button.cornerRadius
        $0.clipsToBounds = true
    }
    
    private(set) var femaleButton = UIButton(type: .system).then {
        $0.setTitle("여성", for: .normal)
        $0.setTitleColor(UIColor.Text.secondaryColor, for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(size: 18, family: .medium)
        $0.backgroundColor = UIColor.Background.secondaryColor
        $0.layer.cornerRadius = Constants.Button.cornerRadius
        $0.clipsToBounds = true
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
        self.addSubview(genderStackView)
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
        
        genderStackView.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(40)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.height
                .equalTo(Constants.Button.height)
        }
    }
}
