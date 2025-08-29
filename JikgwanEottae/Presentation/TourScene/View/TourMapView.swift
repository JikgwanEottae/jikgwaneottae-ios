//
//  TourMapView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/19/25.
//

import UIKit

import KakaoMapsSDK
import SnapKit
import Then

final class TourMapView: UIView {
    // 관광 카테고리 선택을 위한 칩 바입니다.
    public let categoryChipBar = horizontalChipBar(
        titles: TourType.allCases.map { $0.description }
    )
    // 카카오 맵을 담는 컨테이너 뷰입니다.
    public var mapContainer = KMViewContainer()
    // 지도를 초기 위치로 재설정하는 버튼입니다.
    public let resetCoordinateButton = UIButton(type: .custom).then {
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

    // 상태에 따라 기능이 변경되는 중앙 액션 버튼입니다.
    public let centerActionButton = UIButton().then {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .mainCharcoalColor
        config.background.cornerRadius = 20
        config.imagePadding = 5
        config.imagePlacement = .leading
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowRadius = 6
        $0.configuration = config
    }
//    // 리스트로 보여주기 위한 버튼입니다.
//    public let showListButton = UIButton().then {
//        var config = UIButton.Configuration.filled()
//        // 이미지 설정
//        config.image = UIImage(
//            systemName: "list.bullet",
//            withConfiguration: UIImage.SymbolConfiguration(
//                pointSize: 15,
//                weight: .bold
//            )
//        )
//        config.cornerStyle = .capsule
//        config.baseBackgroundColor = .white
//        config.baseForegroundColor = .mainCharcoalColor
//        $0.layer.shadowColor = UIColor.black.cgColor
//        $0.layer.shadowOpacity = 0.3
//        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
//        $0.layer.shadowRadius = 6
//        $0.configuration = config
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        updateCenterButtonState(isSearchMode: false)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resetCoordinateButton.layer.cornerRadius = resetCoordinateButton.bounds.width / 2.0
//        showListButton.layer.cornerRadius = showListButton.bounds.width / 2.0
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(categoryChipBar)
        self.addSubview(mapContainer)
        mapContainer.addSubview(resetCoordinateButton)
        mapContainer.addSubview(centerActionButton)
//        mapContainer.addSubview(showListButton)
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
        
        resetCoordinateButton.snp.makeConstraints { make in
            make.leading
                .equalToSuperview()
                .inset(30)
            make.centerY
                .equalTo(centerActionButton)
            make.size
                .equalTo(40)
        }
        
        centerActionButton.snp.makeConstraints { make in
            make.leading
                .greaterThanOrEqualTo(resetCoordinateButton.snp.trailing)
                .offset(15)
                .priority(.required)
            make.centerX
                .equalToSuperview()
            make.bottom
                .equalToSuperview()
                .inset(40)
            make.height
                .equalTo(35)
        }
        
//        showListButton.snp.makeConstraints { make in
//            make.trailing
//                .equalToSuperview()
//                .inset(30)
//            make.centerY
//                .equalTo(centerActionButton)
//            make.size
//                .equalTo(40)
//        }
    }
    /// 센터 버튼의 상태를 변경합니다.
    public func updateCenterButtonState(isSearchMode: Bool) {
        var config = centerActionButton.configuration ?? UIButton.Configuration.filled()
        var attributedTitle: AttributedString
        let imageName: String
        if isSearchMode == true {
            attributedTitle = AttributedString("장소 더보기")
            imageName = "plus"
        } else {
            attributedTitle = AttributedString("이 지역 검색하기")
            imageName = "arrow.clockwise"
        }
        attributedTitle.font = UIFont.gMarketSans(size: 14, family: .medium)
        attributedTitle.foregroundColor = UIColor.mainCharcoalColor
        config.attributedTitle = attributedTitle
        config.image = UIImage(
            systemName: imageName,
            withConfiguration: UIImage.SymbolConfiguration(pointSize: 12, weight: .semibold)
        )
        centerActionButton.configuration = config
    }
}
