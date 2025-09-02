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
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            titleLabel,
            textField,
            underlineView
        ]
    ).then {
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 12
    }
    private let titleLabel = UILabel().then {
        $0.font = .gMarketSans(size: 13, family: .medium)
        $0.textColor = .primaryTextColor
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    private(set) var textField = UITextField().then {
        $0.setPlaceholder(color: .placeholderColor)
        $0.font = .gMarketSans(size: 17, family: .medium)
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)

    }
    
    private func setupUI() {
        addSubview(stackView)
    }
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        underlineView.snp.makeConstraints { make in
            make.height
                .equalTo(2)
        }
    }
    public func setUnderlineColor(_ color: UIColor) {
        underlineView.backgroundColor = color
    }
}
