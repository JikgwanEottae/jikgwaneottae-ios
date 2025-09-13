//
//  TourPlaceDetailView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/30/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

// MARK: - 관광 장소 상세보기를 위한 뷰입니다.

final class TourPlaceDetailView: UIView {
    // 액티비티 인티케이터
    public let activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = .mainCharcoalColor
    }
    
    // 관광 데이터 팝업 뷰입니다.
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.clipsToBounds = true
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = false
    }
    
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            imageView,
            titleLabel,
            addressLabel,
            overviewLabel
        ]
    ).then {
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 30
        $0.clipsToBounds = true
    }
    
    // 대표 사진입니다.
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    // 제목 레이블입니다.
    private let titleLabel = UILabel().then {
        $0.font = UIFont.gMarketSans(size: 20, family: .medium)
        $0.numberOfLines = 0
        $0.textColor = .primaryTextColor
    }
    
    // 주소 레이블입니다.
    private let addressLabel = UILabel().then {
        $0.font = UIFont.gMarketSans(size: 14, family: .medium)
        $0.numberOfLines = 0
        $0.textColor = .secondaryTextColor
    }
    
    // 상세 정보 레이블입니다.
    private let overviewLabel = UILabel().then {
        $0.font = UIFont.gMarketSans(size: 14, family: .medium)
        $0.numberOfLines = 0
        $0.textColor = .secondaryTextColor
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
        self.backgroundColor = .black.withAlphaComponent(0.25)
        self.addSubview(popupView)
        popupView.addSubview(scrollView)
        popupView.addSubview(activityIndicator)
        scrollView.addSubview(stackView)
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
                .inset(14)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges
                .equalTo(scrollView.contentLayoutGuide)
            make.width
                .equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.setCustomSpacing(20, after: titleLabel)
        stackView.setCustomSpacing(20, after: addressLabel)
        
        popupView.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
            make.height
                .equalTo(450)
            make.width
                .equalToSuperview()
                .multipliedBy(0.8)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
    
        imageView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
    }
    
    public func configure(with tourPlace: TourPlace) {
        updateImage(with: tourPlace.imageURL)
        updateTitle(with: tourPlace.title)
        updateAddress(
            baseAddress: tourPlace.baseAddress,
            subAddress: tourPlace.subAddress,
            zipCode: tourPlace.zipCode
        )
        updateOverview(with: tourPlace.overview)
    }
    
    /// 이미지를 업데이트합니다.
    private func updateImage(with urlString: String) {
        guard !urlString.isEmpty, let url = URL(string: urlString) else {
            imageView.image = UIImage(named: "imagePlaceholder")
            return
        }
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: url)
    }
    
    /// 제목을 업데이트합니다.
    private func updateTitle(with text: String) {
        titleLabel.text = text
        titleLabel.setLineSpacing(spacing: 5)
    }
    
    /// 주소를 업데이트합니다.
    private func updateAddress(
        baseAddress: String,
        subAddress: String,
        zipCode: String
    ) {
        let addressParts = [
            baseAddress,
            subAddress,
            zipCode
        ]
        let fullAddress = addressParts
            .filter { !$0.isEmpty }
            .joined(separator: " ")
        addressLabel.text = fullAddress
        addressLabel.setLineSpacing(spacing: 5)
    }
    
    /// 소개글을 업데이트합니다.
    private func updateOverview(with text: String?) {
        guard let text = text else { return }
        overviewLabel.text = (text == "-" ? "아직 소개글이 등록되지 않은 곳이에요" : text)
        overviewLabel.setLineSpacing(spacing: 8)
    }
}
