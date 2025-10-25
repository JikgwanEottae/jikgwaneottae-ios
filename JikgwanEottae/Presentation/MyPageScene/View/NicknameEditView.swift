//
//  NicknameEditView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/6/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 사용자의 프로필 닉네임을 설정하기 위한 뷰입니다.

final class NicknameEditView: UIView {
    public let activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = UIColor.Custom.charcoal
    }
    
    private(set) var titleLabel = UILabel().then {
        $0.text = "닉네임을 입력해주세요"
        $0.numberOfLines = 0
        $0.font = UIFont.pretendard(size: 22, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
    }
    
    private(set) var nicknameInputField = UnderlinedInputField(
        title: "닉네임",
        placeholder: "닉네임을 입력해주세요"
    )
    
    private(set) var noticeLabel = UILabel().then {
        $0.text = "한글, 영문, 숫자를 조합해서 입력해주세요. (2-10자)"
        $0.font = UIFont.pretendard(size: 11, family: .medium)
        $0.textColor = UIColor.Custom.red
        $0.numberOfLines = 1
        $0.isHidden = true
    }
    
    private(set) var completeButton = UIButton(type: .custom).then {
        $0.setTitle("수정하기", for: .normal)
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
        setupNicknameTextField()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(activityIndicator)
        self.addSubview(titleLabel)
        self.addSubview(nicknameInputField)
        self.addSubview(noticeLabel)
        self.addSubview(completeButton)
    }
    
    private func setupLayout() {
        activityIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top
                .equalTo(safeAreaLayoutGuide)
                .offset(20)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        nicknameInputField.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(50)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        noticeLabel.snp.makeConstraints { make in
            make.top
                .equalTo(nicknameInputField.snp.bottom)
                .offset(10)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.bottom
                .equalTo(keyboardLayoutGuide.snp.top)
                .offset(-10)
            make.height
                .equalTo(Constants.Button.height)
        }
    }
}

extension NicknameEditView {
    private func setupNicknameTextField() {
        nicknameInputField.textField.text = UserDefaultsManager.shared.nickname
    }
}
