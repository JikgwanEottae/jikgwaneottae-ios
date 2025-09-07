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

final class SignInView: UIView {
    private(set) var kakaoSignInButton = UIButton(type: .custom).then {
        let image = UIImage(named: "kakaoLogin")
        $0.setBackgroundImage(image, for: .normal)
        $0.layer.cornerRadius = Constants.buttonCornerRadius
        $0.clipsToBounds = true
    }
    
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
        self.addSubview(kakaoSignInButton)
        self.addSubview(appleSignInButton)
    }
    
    private func setupLayout() {
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
