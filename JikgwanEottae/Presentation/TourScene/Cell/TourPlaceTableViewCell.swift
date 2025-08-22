//
//  TourPlaceTableViewCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/21/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

// MARK: - 관광 정보를 보여주기 위한 커스텀 테이블 뷰 셀입니다.

final class TourPlaceTableViewCell: UITableViewCell {
    // 재사용 식별 아이디입니다.
    static let ID = "TourPlaceTableViewCell"
    
    // 썸네일을 보여주기 위한 이미지 뷰입니다.
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 17
    }
    
    // 장소 제목을 표시하기 위한 레이블입니다.
    private let titleLabel = UILabel().then {
        $0.font = .gMarketSans(size: 17, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .primaryTextColor
    }
    
    // 주소를 표시하기 위한 레이블입니다.
    private let addressLabel = UILabel().then {
        $0.font = .gMarketSans(size: 13, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .secondaryTextColor
    }
    
    // 거리를 표시하기 위한 레이블입니다.
    private let distanceLabel = UILabel().then {
        $0.font = .gMarketSans(size: 13, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = .secondaryTextColor
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = nil
        titleLabel.text = nil
        addressLabel.text = nil
        distanceLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: 15,
                right: 0
            )
        )
    }
    
    private func setupUI() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(distanceLabel)
        self.selectionStyle = .none
    }
    
    private func setupLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.top.bottom.leading
                .equalToSuperview()
            make.width
                .equalTo(thumbnailImageView.snp.height)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top
                .equalToSuperview()
                .inset(10)
            make.leading
                .equalTo(thumbnailImageView.snp.trailing)
                .offset(15)
            make.trailing
                .equalToSuperview()
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(11)
            make.leading
                .equalTo(thumbnailImageView.snp.trailing)
                .offset(15)
            make.trailing
                .equalToSuperview()
        }
        
        distanceLabel.snp.makeConstraints { make in
            make.top
                .equalTo(addressLabel.snp.bottom)
                .offset(11)
            make.leading
                .equalTo(thumbnailImageView.snp.trailing)
                .offset(15)
            make.trailing
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
                .inset(10)
        }
        
    }
    
    public func configure(thumbnail: String, title: String, address: String, distance: Double) {
        if let url = URL(string: thumbnail) {
            thumbnailImageView.kf.setImage(with: url)
        }
        titleLabel.text = title
        addressLabel.text = address
        distanceLabel.text = "\(Int(distance))m"
    }
}
