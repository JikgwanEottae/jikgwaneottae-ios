//
//  SettingCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/8/25.
//

import UIKit

import SnapKit
import Then

final class SettingCell: UITableViewCell {
    static let ID = "SettingCell"
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 12, family: .semiBold)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 1
        $0.textAlignment = .left
    }
    
    private let rightImageView = UIImageView().then {
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        $0.image = UIImage(
            systemName: "chevron.right",
            withConfiguration: config)?.withTintColor(
                UIColor.Text.tertiaryColor,
                renderingMode: .alwaysOriginal
            )
        $0.contentMode = .scaleAspectFit
        $0.setContentHuggingPriority(.required, for: .horizontal)
        $0.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    private func setupUI() {
        selectionStyle = .none
        self.backgroundColor = UIColor.Background.secondaryColor
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(rightImageView)
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.bottom.centerY
                .equalToSuperview()
        }
        
        rightImageView.snp.makeConstraints { make in
            make.top.trailing.bottom.centerY
                .equalToSuperview()
        }
    }
    
    public func configure(title: String) {
        titleLabel.text = title
    }
    
}
