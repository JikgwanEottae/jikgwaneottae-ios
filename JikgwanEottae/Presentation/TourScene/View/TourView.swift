//
//  TourView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/19/25.
//

import UIKit

import KakaoMapsSDK
import SnapKit
import Then

final class TourView: UIView {
    // 모든 관광타입 버튼을 표시하는 칩 바입니다.
    public let categoryChipBar = horizontalChipBar(
        titles: TourType.allCases.map { $0.description }
    )
    
    // 카카오 맵 컨테이너입니다.
    public var mapContainer = KMViewContainer()
    
    // 지도의 초기 위치로 돌아가는 버튼입니다.
    public let recenterButton = UIButton(type: .custom).then {
        var config = UIButton.Configuration.filled()
        // 이미지 설정
        config.image = UIImage(
            systemName: "scope",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 15,
                weight: .bold
            )
        )
        config.cornerStyle = .capsule
        // 배경색과 전경색
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .mainCharcoalColor
        // 그림자 설정
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowRadius = 6
        $0.configuration = config
    }
    
    //  해당 지역의 관광 데이터를 검색하기 위한 버튼입니다.
    public let searchNearbyButton = UIButton().then {
        var attributedTitle = AttributedString("이 지역 검색하기")
        attributedTitle.font = UIFont.gMarketSans(size: 14, family: .medium)
        attributedTitle.foregroundColor = UIColor.mainCharcoalColor
        var config = UIButton.Configuration.filled()
        config.attributedTitle = attributedTitle
        let image = UIImage(
            systemName: "arrow.clockwise",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 12,
                weight: .semibold
            )
        )
        config.image = image
        config.imagePadding = 5
        config.imagePlacement = .leading
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .mainCharcoalColor
        config.background.cornerRadius = 20
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowRadius = 6
        $0.configuration = config
    }
    
    // 지도의 Poi가 아닌 리스트로 관광 데이터를 보여주기 위한 버튼입니다.
    public let showListButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        // 이미지 설정
        config.image = UIImage(
            systemName: "list.bullet",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 15,
                weight: .bold
            )
        )
        config.cornerStyle = .capsule
        // 배경색과 전경색
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .mainCharcoalColor
        // 그림자 설정
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowRadius = 6
        $0.configuration = config
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        recenterButton.layer.cornerRadius = recenterButton.bounds.width / 2.0
        showListButton.layer.cornerRadius = showListButton.bounds.width / 2.0
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(categoryChipBar)
        self.addSubview(mapContainer)
        mapContainer.addSubview(recenterButton)
        mapContainer.addSubview(searchNearbyButton)
        mapContainer.addSubview(showListButton)
    }
    
    private func setupLayout() {
        categoryChipBar.snp.makeConstraints { make in
            make.top
                .equalTo(safeAreaLayoutGuide)
            make.leading.trailing
                .equalToSuperview()
            make.height
                .equalTo(55)
        }
        
        mapContainer.snp.makeConstraints { make in
            make.top
                .equalTo(categoryChipBar.snp.bottom)
            make.leading.trailing
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
        }
        
        recenterButton.snp.makeConstraints { make in
            make.leading
                .equalToSuperview()
                .inset(30)
            make.centerY
                .equalTo(searchNearbyButton)
            make.size
                .equalTo(40)
        }
        
        searchNearbyButton.snp.makeConstraints { make in
            make.leading
                .greaterThanOrEqualTo(recenterButton.snp.trailing)
                .offset(15)
                .priority(.required)
            make.trailing
                .lessThanOrEqualTo(showListButton.snp.leading)
                .offset(-15)
                .priority(.required)
            make.centerX
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
                .inset(40)
            make.height
                .equalTo(35)
        }
        
        showListButton.snp.makeConstraints { make in
            make.trailing
                .equalToSuperview()
                .inset(30)
            make.centerY
                .equalTo(searchNearbyButton)
            make.size
                .equalTo(40)
        }
    }
}
