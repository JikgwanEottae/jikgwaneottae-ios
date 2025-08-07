//
//  UnderlinedTextFieldView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/28/25.
//

import UIKit

import SnapKit
import Then

final class UnderlinedTextFieldView: UIView {
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            titleLabel,
            textField,
            underlineView
        ]
    ).then {
        $0.axis = .vertical
        $0.spacing = 10
    }
    private let titleLabel = UILabel().then {
        $0.font = .gMarketSans(size: 14, family: .medium)
        $0.textColor = .primaryTextColor
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    private let textField = UITextField().then {
        $0.placeholder = "좌석을 입력해주세요"
        $0.setPlaceholder(color: .placeholderColor)
        $0.font = .gMarketSans(size: 18, family: .medium)
        $0.textColor = .primaryTextColor
        $0.clearButtonMode = .whileEditing
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.contentVerticalAlignment = .center
    }
    private let underlineView = UIView().then {
        $0.backgroundColor = .primaryBackgroundColor
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
        addSubview(stackView)
    }
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        underlineView.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
            make.height
                .equalTo(1.5)
        }
    }
    public func configure(title: String, placeholder: String, text: String? = nil) {
        titleLabel.text = title
        textField.placeholder = placeholder
    }
    
    public func getTextFieldInput() -> String? {
        return textField.text
    }
}
