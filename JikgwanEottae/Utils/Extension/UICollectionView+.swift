//
//  UICollectionView+.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/8/25.
//

import UIKit

import SnapKit
import Then

extension UICollectionView {
    /// empty 백그라운드 뷰를 생성하는 함수
    func setEmptyView(image: UIImage?, message: String) {
        let stackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .center
            $0.spacing = 30
        }
        
        let imageView = UIImageView().then {
            $0.image = image?.withRenderingMode(.alwaysTemplate)
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .secondaryTextColor
        }
        
        let label = UILabel().then {
            $0.text = message
            $0.font = .paperlogy(size: 17, family: .medium)
            $0.textColor = .secondaryTextColor
            $0.textAlignment = .center
            $0.numberOfLines = 0
        }
        
        let container = UIView(frame: bounds)
        
        container.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        
        stackView.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.width
                .equalTo(35)
        }
        
        backgroundView = container
    }
    /// 백그라운드 뷰를 제거하는 함수
    func restore() {
        backgroundView = nil
    }
}
