//
//  TourListView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/28/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class TourListView: UIView {
    
    // 관광 데이터를 보여주기 위한 테이블 뷰입니다.
    public let tableView = UITableView(
        frame: .zero,
        style: .plain
    ).then {
        $0.register(TourPlaceTableViewCell.self, forCellReuseIdentifier: TourPlaceTableViewCell.ID)
        $0.backgroundColor = .white
        $0.rowHeight = 120
        $0.alwaysBounceVertical = false
        $0.separatorStyle = .none
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(tableView)
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top
                .equalTo(safeAreaLayoutGuide)
                .inset(20)
            make.leading.trailing.bottom
                .equalToSuperview()
        }
    }
}
