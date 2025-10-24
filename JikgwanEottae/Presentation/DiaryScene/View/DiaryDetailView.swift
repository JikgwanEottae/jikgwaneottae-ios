//
//  DiaryDetailView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/28/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 직관 일기 상세보기를 위한 뷰입니다.

final class DiaryDetailView: UIView {
    private(set) var activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = UIColor.Custom.charcoal
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.contentInset = UIEdgeInsets(
            top: Constants.EdgeInset.top,
            left: 0,
            bottom: 0,
            right: 0
        )
        $0.scrollIndicatorInsets = $0.contentInset
    }
    
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            thumbnailImageView,
            titleContainerView,
            contentContainerView,
            gameInfoContainerView,
            metaInfoContainerView,
            dateContainerView
        ]
    ).then {
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 10
        $0.clipsToBounds = true
    }
    
    // 썸네일 이미지
    private let thumbnailImageView = UIImageView().then {
        $0.image = UIImage(named: "test3")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 17
    }
    
    // 일기 제목을 감싸는 컨테이너
    private let titleContainerView = UIView()
    
    // 일기 제목
    private(set) var titleLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 22, family: .bold)
        $0.numberOfLines = 0
        $0.textColor = UIColor.Text.primaryColor
        $0.textAlignment = .left
        $0.clipsToBounds = true
    }
    
    // 컨텐츠를 감싸는 컨테이너
    private let contentContainerView = UIView()
    
    private(set) var contentTextView = UITextView().then {
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.textColor = UIColor.Text.secondaryColor
        $0.textContainer.lineFragmentPadding = 0
        $0.textContainerInset = .zero
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.clipsToBounds = true
    }
    
    // 경기 결과를 감싸는 컨테이너
    private let gameInfoContainerView = UIView()
    
    // 경기 결과
    private(set) var gameInfoLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = UIColor.Text.tertiaryColor
        $0.textAlignment = .left
        $0.clipsToBounds = true
    }
    
    // 메타 정보를 감싸는 컨테이너
    private let metaInfoContainerView = UIView()
    
    // 메타 정보(경기장 + 날짜 + 좌석)
    private(set) var metaInfoLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.numberOfLines = 0
        $0.textColor = UIColor.Text.tertiaryColor
        $0.textAlignment = .left
        $0.clipsToBounds = true
    }
    
    // 직관 날짜를 감싸는 컨테이너
    private let dateContainerView = UIView()
    
    // 경기 날짜
    private(set) var dateInfoLabel = UILabel().then {
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.clipsToBounds = true
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
        backgroundColor = .white
        self.addSubview(scrollView)
        self.addSubview(activityIndicator)
        scrollView.addSubview(stackView)
        titleContainerView.addSubview(titleLabel)
        gameInfoContainerView.addSubview(gameInfoLabel)
        metaInfoContainerView.addSubview(metaInfoLabel)
        contentContainerView.addSubview(contentTextView)
        dateContainerView.addSubview(dateInfoLabel)
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges
                .equalTo(scrollView.contentLayoutGuide)
            make.width
                .equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.setCustomSpacing(30, after: thumbnailImageView)
        stackView.setCustomSpacing(10, after: contentContainerView)
        stackView.setCustomSpacing(5, after: gameInfoContainerView)
        stackView.setCustomSpacing(5, after: metaInfoContainerView)
        
        thumbnailImageView.snp.makeConstraints { make in
            make.height
                .equalTo(thumbnailImageView.snp.width)
            make.leading.trailing
                .equalToSuperview()
                .inset(8)
        }
        
        [titleLabel, gameInfoLabel, metaInfoLabel, contentTextView, dateInfoLabel].forEach {
            $0.snp.makeConstraints { make in
                make.top.bottom
                    .equalToSuperview()
                make.leading.trailing
                    .equalToSuperview()
                    .inset(6)
            }
        }
    }
    
    public func configureImage(with urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString)
        else {
            thumbnailImageView.image = UIImage(named: "placeholder")
            return
        }
        thumbnailImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholder"),
            options: [.transition(.fade(0.25))]
        )
    }
}
