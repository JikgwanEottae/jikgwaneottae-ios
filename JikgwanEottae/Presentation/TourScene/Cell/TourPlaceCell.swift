//
//  TourPlaceCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/21/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

// MARK: - 관광 정보를 보여주기 위한 커스텀 테이블 뷰 셀입니다.

final class TourPlaceCell: UITableViewCell {
    // 재사용 식별 아이디입니다.
    static let ID = "TourPlaceCell"
    
    // 썸네일을 보여주기 위한 이미지 뷰입니다.
    private let thumbnailImageView = UIImageView().then {
        $0.image = UIImage(named: "imagePlaceholder")
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
        $0.numberOfLines = 2
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
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = UIImage(named: "imagePlaceholder")
        titleLabel.text = nil
        addressLabel.text = nil
        distanceLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(
                top: 0,
                left: 12,
                bottom: 15,
                right: 12
            )
        )
    }
    
    private func setupUI() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(distanceLabel)
        selectionStyle = .none
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
            make.centerY.trailing
                .equalToSuperview()
            make.leading
                .equalTo(thumbnailImageView.snp.trailing)
                .offset(15)
            make.top
                .greaterThanOrEqualTo(titleLabel.snp.bottom)
                .offset(5)
            make.bottom
                .lessThanOrEqualTo(distanceLabel.snp.top)
                .offset(-5)
        }
        
        distanceLabel.snp.makeConstraints { make in
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
    
    public func configure(with tourPlace: TourPlace) {
        if !tourPlace.imageURL.isEmpty, let url = URL(string: tourPlace.imageURL) {
            thumbnailImageView.kf.indicatorType = .activity
            thumbnailImageView.kf.setImage(with: url)
        }
        titleLabel.text = tourPlace.title
        addressLabel.text = tourPlace.baseAddress
        addressLabel.setLineSpacing(spacing: 5)
        guard let distance = tourPlace.distance else { return }
        distanceLabel.text = "\(Int(distance))m"
    }
}
