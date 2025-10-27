//
//  WithdrawalView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/10/25.
//

import UIKit

import SnapKit
import Then

final class WithdrawalView: UIView {
    public let activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = UIColor.Custom.charcoal
    }
    
    private let titleInfoLabel = UILabel().then {
        $0.text = "잠깐! 그전에 확인해 주세요"
        $0.font = UIFont.pretendard(size: 22, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.numberOfLines = 1
    }
    
    private let subTitleInfoLabel = UILabel().then {
        $0.text = "모든 활동 정보가 영구적으로 삭제되며\n다시 복구할 수 없어요"
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 0
        $0.setLineSpacing(spacing: 5)
    }
    
    private(set) var withdrawButton = UIButton(type: .custom).then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(size: 18, family: .semiBold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.Custom.blue
        $0.layer.cornerRadius = 17
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
        self.backgroundColor = .white
        self.addSubview(activityIndicator)
        self.addSubview(titleInfoLabel)
        self.addSubview(subTitleInfoLabel)
        self.addSubview(withdrawButton)
    }
    
    private func setupLayout() {
        activityIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
        
        titleInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
                .offset(20)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        subTitleInfoLabel.snp.makeConstraints { make in
            make.top
                .equalTo(titleInfoLabel.snp.bottom)
                .offset(12)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        withdrawButton.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.bottom
                .equalTo(safeAreaLayoutGuide)
                .inset(10)
            make.height
                .equalTo(Constants.Button.height)
        }
    }

}
