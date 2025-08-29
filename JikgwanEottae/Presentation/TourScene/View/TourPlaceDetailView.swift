//
//  TourPlaceDetailView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/30/25.
//

import UIKit

import SnapKit
import Then

final class TourPlaceDetailView: UIView {
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
//        $0.image = UIImage(named: "imagePlaceholder")
        $0.image = UIImage(named: "test5")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    
    // 제목 레이블입니다.
    private let titleLabel = UILabel().then {
        $0.text = "롯데월드 민속박물관"
        $0.font = UIFont.gMarketSans(size: 20, family: .medium)
        $0.numberOfLines = 0
        $0.textColor = .primaryTextColor
    }
    
    // 주소 레이블입니다.
    private let addressLabel = UILabel().then {
        $0.text = "서울특별시 송파구 올림픽로 240 (잠실동)"
        $0.font = UIFont.gMarketSans(size: 14, family: .medium)
        $0.numberOfLines = 0
        $0.textColor = .secondaryTextColor
    }
    
    // 상세 정보 레이블입니다.
    private let overviewLabel = UILabel().then {
        $0.text = "롯데월드 민속박물관은 1989년 1월 14일 롯데그룹 문화사업의 일환으로 송파 장터와 송파 산대놀이의 고장 잠실에 총면적 8,039㎡ 규모로 개관하였다. 구석기시대부터 조선시대까지의 우리 역사를 시대별로 구분하여 실제 유물 및 재현 모형을 통해 알기 쉽고 재미있게 관람이 가능하도록 전시되어 있다. 특히, 모형 촌은 8분의 1로 축소된 2천여 점의 인형을 이용하여 조선시대의 사계절과 세시풍속, 관혼상제, 양반과 서민들의 생활모습을 사실적으로 표현하였다. 전국의 유명하고 역사적인 유적을 전문인의 고증을 바탕으로 모형으로 재현하여 유적지에 직접 가지 않고도 한 곳에서 관람 가능하다. \n일반적으로 박물관의 역할이 유물의 수집 및 전시 중심에 있다면, 롯데월드 민속박물관은 5,000년 우리 역사와 전통문화를 세계에 알리는 관광명소이다. 진로 탐색과 역사 교육 등 다양한 교육 프로그램 및 전통 공예 체험 프로그램을 통해 직접 체험하며 즐기는 문화공간으로서의 역할을 이행하고 있다."
        $0.font = UIFont.gMarketSans(size: 14, family: .medium)
        $0.numberOfLines = 0
        $0.textColor = .secondaryTextColor
        $0.setLineSpacing(spacing: 8)
    }
    
    private let shadowOverlayView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.shadowColor = UIColor.white.cgColor // 그림자 색상
        $0.layer.shadowOpacity = 1 // 불투명도
        $0.layer.shadowRadius = 10 // 그림자가 퍼지는 반경
        $0.layer.shadowOffset = CGSize(width: 0, height: 0) // 그림자 방향
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
        popupView.addSubview(shadowOverlayView)
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
        
        stackView.setCustomSpacing(17, after: titleLabel)
        stackView.setCustomSpacing(17, after: addressLabel)
        
        popupView.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
            make.height
                .equalTo(500)
            make.width
                .equalToSuperview()
                .multipliedBy(0.8)
        }
    
        imageView.snp.makeConstraints { make in
            make.height.equalTo(200)
        }
        
        shadowOverlayView.snp.makeConstraints { make in
            make.leading.trailing.bottom
                .equalToSuperview()
            make.height
                .equalTo(10)
        }
    }
}
