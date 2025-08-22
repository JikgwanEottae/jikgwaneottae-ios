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
    public let categoryChipBar = horizontalChipBar(
        titles: ["음식", "쇼핑", "관광", "문화시설", "행사", "여행", "레저", "숙박"]
    )
    
    public var mapContainer = KMViewContainer()
    
    // 지도의 초기 위치로 돌아가는 버튼입니다.
    public let recenterButton = UIButton(type: .custom).then {
        let image = UIImage(named: "crosshairs")?.withRenderingMode(.alwaysTemplate)
        $0.setImage(image, for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .mainCharcoalColor
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowOffset = CGSize(width: 0, height: 3)
        $0.layer.shadowRadius = 6
        $0.adjustsImageWhenHighlighted = false
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
    }
    
    private func setupUI() {
        self.backgroundColor = .white
        self.addSubview(categoryChipBar)
        self.addSubview(mapContainer)
        mapContainer.addSubview(recenterButton)
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
            make.bottom
                .equalToSuperview()
                .inset(50)
            make.size
                .equalTo(50)
        }
    }
}
