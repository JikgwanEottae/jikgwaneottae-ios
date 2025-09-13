//
//  MyPageView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/7/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class MyPageView: UIView {
    public let titleLabel = UILabel().then {
        $0.text = "마이"
        $0.numberOfLines = 1
        $0.font = UIFont.gMarketSans(size: 24, family: .bold)
        $0.textColor = .black
    }
    
    public let activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = .mainCharcoalColor
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
    
    private let profileImageContainerView = UIView().then {
        $0.layer.cornerRadius = 70
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowOffset = CGSize(width: 0, height: 4)
        $0.layer.shadowRadius = 8
        $0.clipsToBounds = false
    }
    
    private let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 70
        $0.image = UIImage(named: "placeholder")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    private(set) var profileEditButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "plus.circle.fill")
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 22)
        config.baseForegroundColor = .mainCharcoalColor
        config.background.backgroundColor = .white
        config.cornerStyle = .capsule
        $0.configuration = config
        $0.clipsToBounds = true
    }
    
    public let nicknameLabel = UILabel().then {
        $0.text = UserDefaultsManager.shared.nickname
        $0.numberOfLines = 1
        $0.font = UIFont.gMarketSans(size: 17, family: .bold)
        $0.textColor = .primaryTextColor
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setupProfileImage()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(tableView)
        self.addSubview(activityIndicator)
        headerView.addSubview(profileImageContainerView)
        headerView.addSubview(nicknameLabel)
        profileImageContainerView.addSubview(profileImageView)
        profileImageContainerView.addSubview(profileEditButton)
    }
    
    private func setupLayout() {
        activityIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
        profileImageContainerView.snp.makeConstraints { make in
            make.top
                .equalToSuperview()
                .offset(20)
            make.centerX
                .equalToSuperview()
            make.size
                .equalTo(140)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
        profileEditButton.snp.makeConstraints { make in
            make.trailing.bottom
                .equalToSuperview()
            make.size
                .equalTo(34)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top
                .equalTo(profileImageContainerView.snp.bottom)
                .offset(5)
            make.centerX
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
                .offset(-5)
        }
    }
}

extension MyPageView {
    /// 초기 프로필 이미지를 설정합니다.
    public func setupProfileImage() {
        if let profileImage = UserDefaultsManager.shared.profileImageURL {
            let url = URL(string: profileImage)
            profileImageView.kf.setImage(with: url)
        } else {
            profileImageView.image = UIImage(named: "placeholder")
        }
    }
    
    /// 프로필 닉네임을 업데이트합니다.
    public func updateProfileNickname(_ nickname: String?) {
        nicknameLabel.text = nickname
    }
}
