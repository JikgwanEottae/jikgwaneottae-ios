//
//  DiaryCollectionViewCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/27/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class DiaryCollectionViewCell: UICollectionViewCell {

    static let ID = "DiaryCollectionViewCell"

    // 썸네일 이미지
    private let thumbnailImageView = UIImageView().then {
        $0.image = UIImage(named: "placeholder")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.kf.indicatorType = .activity
    }
    
    // 그라데이션 뷰
    private(set) var gradientView = UIView()
    
    // 그라데이션 레이어
    private(set) lazy var gradientLayer = CAGradientLayer().then {
        $0.colors = [
            UIColor.black.withAlphaComponent(0.0).cgColor,
            UIColor.black.withAlphaComponent(0.6).cgColor,
            UIColor.black.withAlphaComponent(0.9).cgColor
        ]
        $0.locations = [0.0, 0.5, 1.0]
        $0.startPoint = CGPoint(x: 0.5, y: 0.0)
        $0.endPoint = CGPoint(x: 0.5, y: 1.0)
        $0.isHidden = true
    }

    // 일기 제목
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 13, family: .semiBold)
        $0.setLineSpacing(spacing: 5)
        $0.numberOfLines = 2
        $0.textColor = UIColor.white
        $0.textAlignment = .left
        $0.lineBreakStrategy = .hangulWordPriority
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setupUI()
        setupLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.image = UIImage(named: "placeholder")
        titleLabel.text = nil
        titleLabel.textColor = UIColor.white
        gradientLayer.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.layoutIfNeeded()
        gradientLayer.frame = gradientView.bounds
     }
    
    private func addSubViews() {
        contentView.addSubview(thumbnailImageView)
        contentView.addSubview(gradientView)
        gradientView.layer.addSublayer(gradientLayer)
        contentView.addSubview(titleLabel)
    }

    private func setupUI() {
        backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 14
        contentView.clipsToBounds = true
    }

    private func setupLayout() {
        thumbnailImageView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
        gradientView.snp.makeConstraints { make in
            make.leading.trailing.bottom
                .equalToSuperview()
            make.height
                .equalTo(100)
        }

        titleLabel.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(10)
            make.bottom
                .equalToSuperview()
                .inset(15)
        }
    }
}

// MARK: - Extension

extension DiaryCollectionViewCell {
    public func configure(with diary: Diary) {
        titleLabel.text = diary.title
        guard let imageUrlStr = diary.imageURL,
              let url = URL(string: imageUrlStr)
        else {
            titleLabel.textColor = UIColor.Text.secondaryColor
            return
        }
        thumbnailImageView.kf.setImage(with: url) { [weak self] result in
            guard case .success = result else { return }
            self?.gradientLayer.isHidden = false
        }
    }
}
