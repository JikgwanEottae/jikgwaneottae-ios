//
//  RecordCollectionViewCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/24/25.
//

import UIKit

import SnapKit
import Then

final class RecordTableViewCell: UITableViewCell {

    static let ID = "RecordTableViewCell"
    
    private let view = UIView().then {
        $0.backgroundColor = .systemRed
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.addSubview(view)
    }
    
    private func setuplayout() {
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}
