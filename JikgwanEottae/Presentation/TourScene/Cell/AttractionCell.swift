//
//  AttractionCell.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import UIKit

import SnapKit
import Then

final class AttractionCell: UITableViewCell {
    static let ID = "AttractionCell"
    
    private let rankingLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 16, family: .bold)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.textAlignment = .left
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 16, family: .medium)
        $0.textColor = UIColor.Text.primaryColor
        $0.numberOfLines = 1
    }
    
    private let addressLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 12, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 1
    }
    
    private let categoryLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 12, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 1
    }
    
    private lazy var infoStackView = UIStackView(
        arrangedSubviews: [
            titleLabel,
            addressLabel
        ]
    ).then {
        $0.axis = .vertical
        $0.alignment = .leading
        $0.distribution = .equalSpacing
    }
    
    public override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        super.prepareForReuse()
        rankingLabel.text = nil
        rankingLabel.textColor = UIColor.Text.tertiaryColor
        titleLabel.text = nil
        addressLabel.text = nil
        categoryLabel.text = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.contentView.addSubview(rankingLabel)
        self.contentView.addSubview(infoStackView)
        self.contentView.addSubview(categoryLabel)
    }
    
    private func setupLayout() {
        rankingLabel.snp.makeConstraints { make in
            make.centerY.leading
                .equalToSuperview()
        }
        
        infoStackView.snp.makeConstraints { make in
            make.leading
                .equalTo(rankingLabel.snp.trailing)
                .offset(25)
            make.top.bottom
                .equalToSuperview()
                .inset(15)
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading
                .equalTo(infoStackView.snp.trailing)
                .offset(25)
            make.trailing.centerY
                .equalToSuperview()
        }
    }
}

extension AttractionCell {
    public func configure(with attraction: Attraction) {
        configureRanking(attraction.rank)
        configureInfo(
            name: attraction.name,
            city: attraction.city,
            district: attraction.district
        )
        configureCategory(attraction.category)
    }
    
    private func configureRanking(_ rank: Int) {
        rankingLabel.text = "\(rank)위"
        rankingLabel.textColor = (1...3).contains(rank) ? UIColor.Custom.blue : UIColor.Text.tertiaryColor
    }
    
    private func configureInfo(name: String, city: String, district: String) {
        titleLabel.text = name
        addressLabel.text = "\(city) \(district)"
    }
    
    private func configureCategory(_ category: String) {
        categoryLabel.text = category
    }
}
