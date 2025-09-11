//
//  CustomButton.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/11/25.
//

import UIKit

import SnapKit
import Then

final class CustomButton: UIButton {
    
    private let customTitleLabel = UILabel().then {
        $0.font = UIFont.gMarketSans(size: 18, family: .medium)
        $0.textAlignment = .center
        $0.textColor = .white
    }
    
    private let customImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupUI() {
        self.layer.cornerRadius = Constants.buttonCornerRadius
        self.backgroundColor = .black
        self.addSubview(customTitleLabel)
        self.addSubview(customImageView)
    }
    
    private func setupLayout() {
        customTitleLabel.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
            make.top.bottom
                .equalToSuperview()
                .inset(8)
        }
        
        customImageView.snp.makeConstraints { make in
            make.centerY
                .equalToSuperview()
            make.leading
                .equalToSuperview()
                .inset(25)
            make.top.bottom
                .equalToSuperview()
                .inset(15)
            make.width
                .equalTo(customImageView.snp.height)
        }
    }
}

extension CustomButton {
    /// 버튼의 타이틀과 색상을 설정합니다.
    public func setTitle(text: String, textColor: UIColor) {
        customTitleLabel.text = text
        customTitleLabel.textColor = textColor
    }
    
    /// 버튼의 이미지와 색상을 설정합니다.
    public func setImage(_ image: UIImage?, tintColor: UIColor) {
        customImageView.image = image
        customImageView.tintColor = tintColor
    }
}
