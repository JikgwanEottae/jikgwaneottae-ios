//
//  LoginView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/4/25.
//

import AuthenticationServices
import UIKit

import SnapKit
import Then

// MARK: - 첫 화면진입 시 보이는 로그인 뷰입니다.

final class SignInView: UIView {
    // 로고를 보여주는 이미지 뷰입니다.
    private let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "appImageClear")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    // 카카오 로그인 버튼입니다.
    private(set) var kakaoSignInButton = UIButton(type: .custom).then {
        let image = UIImage(named: "kakaoLogin")
        $0.setBackgroundImage(image, for: .normal)
        $0.layer.cornerRadius = Constants.buttonCornerRadius
        $0.clipsToBounds = true
    }
    
    // 애플 로그인 버튼입니다.
    private(set) var appleSignInButton = ASAuthorizationAppleIDButton(
        type: .signIn,
        style: .black).then {
            $0.cornerRadius = Constants.buttonCornerRadius
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
        self.addSubview(logoImageView)
        self.addSubview(kakaoSignInButton)
        self.addSubview(appleSignInButton)
    }
    
    private func setupLayout() {
        logoImageView.snp.makeConstraints { make in
            make.centerX
                .equalToSuperview()
            make.centerY
                .equalToSuperview()
                .offset(-50)
            make.size
                .equalTo(300)
        }
        
        kakaoSignInButton.snp.makeConstraints { make in
            make.leading.trailing
                .equalTo(safeAreaLayoutGuide)
                .inset(20)
            make.height
                .equalTo(Constants.buttonHeight)
            make.bottom
                .equalTo(appleSignInButton.snp.top)
                .offset(-20)
        }
        
        appleSignInButton.snp.makeConstraints { make in
            make.leading.trailing.bottom
                .equalTo(safeAreaLayoutGuide)
                .inset(20)
            make.height
                .equalTo(Constants.buttonHeight)
        }
    }
}
