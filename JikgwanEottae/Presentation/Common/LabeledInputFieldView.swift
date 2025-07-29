//
//  LabeledInputFieldView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/29/25.
//

import UIKit

import SnapKit
import Then

public final class LabeledInputFieldView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.font = .gMarketSans(size: 14, family: .medium)
        $0.textColor = .primaryTextColor
    }
    
    private let containerView = UIView().then {
        $0.backgroundColor = .secondaryBackgroundColor
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.borderColor.cgColor
    }
    
    public let textField = UITextField().then {
        $0.font = .gMarketSans(size: 15, family: .medium)
        $0.textColor = .primaryTextColor
        $0.clearButtonMode = .whileEditing
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.contentVerticalAlignment = .center
    }
    
    public init(title: String, placeholder: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        textField.placeholder = placeholder
        addSubviews()
        setupLayout()
    }
    
    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(textField)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalToSuperview()
        }
        containerView.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(10)
            make.leading.trailing
                .equalToSuperview()
            make.height
                .equalTo(55)
            make.bottom
                .equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.top.bottom
                .equalToSuperview()
                .inset(10)
        }
    }
}
