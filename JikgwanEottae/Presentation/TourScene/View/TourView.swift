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
        self.addSubview(categoryChipBar)
        self.addSubview(mapContainer)
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
                .equalTo(safeAreaLayoutGuide)
        }
    }
}
