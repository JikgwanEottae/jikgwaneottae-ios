//
//  PopupViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/10/25.
//

import UIKit

import SnapKit
import Then

/// 버튼의 스타일을 설정하는 구조체입니다.
public struct PopupButtonStyle {
    let title: String
    let backgroundColor: UIColor
    
    public init(
        title: String,
        backgroundColor: UIColor
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
    }
}

final class PopupViewController: UIViewController {
    // 메인 버튼이 클릭됬을 때 델리게이트입니다.
    public var onMainAction: (() -> Void)?
    
    // 팝업 뷰입니다.
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 35
        $0.clipsToBounds = true
    }
    
    // 블러 효과를 가지는 뷰입니다.
    private let blurEffectView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    // 레이블을 배치하는 스택 뷰입니다.
    private lazy var labelStackView = UIStackView(arrangedSubviews: [
        titleLabel, subtitleLabel
    ]).then {
        $0.axis = .vertical
        $0.spacing = 25
        $0.alignment = .center
    }
    
    // 메인 타이틀 레이블입니다.
    private let titleLabel = UILabel().then {
        $0.font = .gMarketSans(size: 23, family: .medium)
        $0.textColor = .primaryTextColor
        $0.numberOfLines = 1
    }
    
    // 서브 타이틀 레이블입니다.
    private let subtitleLabel = UILabel().then {
        $0.font = .gMarketSans(size: 17, family: .medium)
        $0.textColor = .tertiaryTextColor
    }
    
    // 버튼을 배치하는 스택 뷰입니다.
    private lazy var buttonStackView = UIStackView(arrangedSubviews: [
        subButton, mainButton
    ]).then {
        $0.axis = .horizontal
        $0.spacing = 10
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    // 메인 버튼입니다.
    public let mainButton = UIButton(type: .custom).then {
        $0.titleLabel?.font = .gMarketSans(size: 17, family: .medium)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(mainButtonTapped), for: .touchUpInside)
    }
    
    // 서브 버튼입니다.
    public let subButton = UIButton(type: .custom).then {
        $0.titleLabel?.font = .gMarketSans(size: 17, family: .medium)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.9592481256, green: 0.9657639861, blue: 0.97197932, alpha: 1)
        $0.layer.cornerRadius = 15
        $0.clipsToBounds = true
        $0.addTarget(self, action: #selector(subButtonTapped), for: .touchUpInside)
        $0.isHidden = true
    }
    
    init(
        title: String,
        subtitle: String,
        mainButtonStyle: PopupButtonStyle,
        subButtonStyle: PopupButtonStyle? = nil,
        blurEffect: UIBlurEffect
    ) {
        super.init(nibName: nil, bundle: nil)
        self.blurEffectView.effect = blurEffect
        self.titleLabel.text = title
        self.subtitleLabel.text = subtitle
        mainButton.setTitle(mainButtonStyle.title, for: .normal)
        mainButton.backgroundColor = mainButtonStyle.backgroundColor
        if let subButtonStyle = subButtonStyle {
            subButton.setTitle(subButtonStyle.title, for: .normal)
            subButton.backgroundColor = subButtonStyle.backgroundColor
            subButton.isHidden = false
        }
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
            make.center
                .equalToSuperview()
            make.height
                .equalTo(200)
            make.width
                .equalToSuperview()
                .multipliedBy(0.8)
        }
        
        blurEffectView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
        labelStackView.snp.makeConstraints { make in
            make.centerX
                .equalToSuperview()
            make.leading.trailing.top
                .equalToSuperview()
                .inset(20)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.centerX
                .equalToSuperview()
            make.top
                .greaterThanOrEqualTo(labelStackView.snp.bottom)
                .offset(20)
            make.leading.trailing.bottom
                .equalToSuperview()
                .inset(20)
            make.height
                .equalTo(50)
        }
    }
}

extension PopupViewController {
    /// 메인 버튼이 클릭됬을 때 이벤트입니다
    @objc private func mainButtonTapped() {
        dismiss(animated: true) { [weak self] in
            self?.onMainAction?()
        }
    }
    /// 서브 버튼이 클릭됬을 때 이벤트입니다.
    @objc private func subButtonTapped() {
        dismiss(animated: true)
    }
}
