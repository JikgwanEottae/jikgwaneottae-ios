//
//  TeamTableViewCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/10/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 구단 테이블 뷰 셀입니다.

final class TeamTableViewCell: UITableViewCell {
    static let ID = "TeamTableViewCell"
    
    private let teamTitleLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 18, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        teamTitleLabel.text = nil
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.contentView.addSubview(teamTitleLabel)
    }
    
    private func setupLayout() {
        teamTitleLabel.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.top
                .equalToSuperview()
        }
    }
    
    public func configure(with text: String) {
        teamTitleLabel.text = text
    }

}
