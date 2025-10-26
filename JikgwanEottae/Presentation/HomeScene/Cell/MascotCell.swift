//
//  MascotCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import UIKit

import Then
import SnapKit

// MARK: - 각 구단별 마스코트 캐릭터를 보여주기 위한 커스텀 컬렉션 뷰 셀입니다.

final class MascotCell: UICollectionViewCell {
    
    static let ID = "MascotCell"
    
    private let mascotImages = ["samsung_bunny", "samsung_bear", "samsung_cat"]
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        setRandomMascot()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.contentView.addSubview(imageView)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
    private func setRandomMascot() {
        imageView.image = UIImage(named: mascotImages.randomElement()!)
    }
}
