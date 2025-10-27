//
//  BallparkSelectionCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 구장 선택 테이블 뷰 셀입니다.

final class BallparkSelectionCell: UITableViewCell {
    static let ID = "BallparkSelectionCell"
    
    private let ballparkTitleLabel = UILabel().then {
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
        ballparkTitleLabel.text = nil
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.contentView.addSubview(ballparkTitleLabel)
    }
    
    private func setupLayout() {
        ballparkTitleLabel.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.centerY
                .equalToSuperview()
        }
    }
    
    public func configure(with team: KBOTeam) {
        ballparkTitleLabel.text = "\(team.rawValue) · \(team.ballpark)"
    }

}

