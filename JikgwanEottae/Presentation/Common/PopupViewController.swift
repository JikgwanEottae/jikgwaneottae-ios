//
//  PopupViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/10/25.
//

import UIKit

import SnapKit
import Then

final class PopupViewController: UIViewController {
    
    public var onConfirm: (() -> Void)?
    
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 35
        $0.clipsToBounds = true
    }
    
    private let blurEffectView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private lazy var labelStackView = UIStackView(arrangedSubviews: [
        titleLabel, subtitleLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 25
        $0.alignment = .center
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont(name: "GmarketSansMedium", size: 23)
        $0.textColor = .primaryTextColor
        $0.numberOfLines = 1
    }
    
    private let subtitleLabel = UILabel().then {
        $0.font = UIFont(name: "GmarketSansMedium", size: 17)
        $0.textColor = .tertiaryTextColor
    }
    
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [
        subButton, mainButton
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }

    public let mainButton = UIButton(type: .custom).then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = UIFont(name: "GmarketSansMedium", size: 17)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainCharcoalColor
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
    }
    
    public let subButton = UIButton(type: .custom).then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = UIFont(name: "GmarketSansMedium", size: 17)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .primaryBackgroundColor
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
    }
    
    init(titleText: String, subtitleText: String, isSubButtonHide: Bool = true) {
        self.titleLabel.text = titleText
        self.subtitleLabel.text = subtitleText
        subButton.isHidden = isSubButtonHide
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
    }
    
    private func setupUI() {
        view.addSubview(blurEffectView)
        view.addSubview(popupView)
        popupView.addSubview(labelStackView)
        popupView.addSubview(buttonStackView)
    }
    
    private func setupLayout() {
        popupView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(200)
            make.width.equalToSuperview().multipliedBy(0.8)
        }
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.top.equalToSuperview().inset(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.greaterThanOrEqualTo(labelStackView.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
    }
}

extension PopupViewController {
    @objc
    private func confirmButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onConfirm?()
        }
    }
}

