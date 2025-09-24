//
//  UnderlinedInputField.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/28/25.
//

import UIKit

import SnapKit
import Then

final class UnderlinedInputField: UIView {
    private let titleLabel = UILabel().then {
        $0.font = .paperlogy(size: 13, family: .medium)
        $0.textColor = .primaryTextColor
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let containerView = UIView()
    
    private(set) var textField = UITextField().then {
        $0.setPlaceholder(color: .placeholderColor)
        $0.font = .paperlogy(size: 16, family: .medium)
        $0.textColor = .primaryTextColor
        $0.clearButtonMode = .always
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.contentVerticalAlignment = .center
    }
    
    private let underlineView = UIView().then {
        $0.backgroundColor = .primaryBackgroundColor
    }

    init(title: String, placeholder: String, inputView: UIView? = nil) {
        titleLabel.text = title
        textField.placeholder = placeholder
        if let inputView = inputView {
            textField.inputView = inputView
            textField.tintColor = .clear
        }
        super.init(frame: .zero)
        setupUI()
        setupLayout()
    }
    
    convenience init(title: String, placeholder: String, customView: UIView) {
        self.init(title: title, placeholder: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    private func setupUI() {
        self.addSubview(titleLabel)
        self.addSubview(containerView)
        self.addSubview(underlineView)
        self.containerView.addSubview(textField)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalToSuperview()
        }
        
        containerView.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
            make.leading.trailing.bottom
                .equalToSuperview()
            make.height
                .equalTo(35)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
            make.top.bottom
                .equalToSuperview()
                .inset(5)
        }
        
        underlineView.snp.makeConstraints { make in
            make.height
                .equalTo(2)
            make.leading.trailing.bottom
                .equalToSuperview()
        }
    }
    
    public func setUnderlineColor(_ color: UIColor) {
        underlineView.backgroundColor = color
    }
}
