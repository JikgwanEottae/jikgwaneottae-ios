//
//  MyPageView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/7/25.
//

import UIKit

import SnapKit
import Then

final class MyPageView: UIView {
    public let titleLabel = UILabel().then {
        $0.text = "마이"
        $0.numberOfLines = 1
        $0.font = UIFont.gMarketSans(size: 24, family: .bold)
        $0.textColor = .black
    }
    
    private(set) var tableView = UITableView(
        frame: .zero,
        style: .insetGrouped
    ).then {
        $0.rowHeight = 50
        $0.register(SettingCell.self, forCellReuseIdentifier: SettingCell.ID)
        $0.backgroundColor = .white
    }
    
    private(set) var headerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.clipsToBounds = true
    }
    
    private let imageContainerView = UIView().then {
        $0.layer.cornerRadius = 70
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 8
        $0.clipsToBounds = false
    }
    
    private let imageView = UIImageView().then {
        $0.layer.cornerRadius = 70
        $0.image = UIImage(named: "seulgi")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    public let nicknameLabel = UILabel().then {
        $0.text = "슬기로운 생활"
        $0.numberOfLines = 1
        $0.font = UIFont.gMarketSans(size: 17, family: .bold)
        $0.textColor = .primaryTextColor
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(tableView)
        headerView.addSubview(imageContainerView)
        headerView.addSubview(nicknameLabel)
        imageContainerView.addSubview(imageView)
    }
    
    private func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
        imageContainerView.snp.makeConstraints { make in
            make.top
                .equalToSuperview()
                .offset(20)
            make.centerX
                .equalToSuperview()
            make.size
                .equalTo(140)
        }
        
        imageView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top
                .equalTo(imageContainerView.snp.bottom)
                .offset(20)
            make.centerX
                .equalToSuperview()
        }
    }

}
