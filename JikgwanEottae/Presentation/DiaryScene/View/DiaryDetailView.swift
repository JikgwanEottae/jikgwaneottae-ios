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
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
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
            gameInfoContainerView,
            metaInfoContainerView,
            memoContainerView,
            dateContainerView
        ]
    ).then {
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 15
        $0.clipsToBounds = true
    }
    
    // 썸네일 이미지
    private let thumbnailImageView = UIImageView().then {
        $0.image = UIImage(named: "test3")
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // 일기 제목을 감싸는 컨테이너
    private let titleContainerView = UIView()
    
    // 일기 제목
    private let titleLabel = UILabel().then {
        $0.text = "오늘의 삼성 승리요정은 바로 나"
        $0.font = UIFont.pretendard(size: 26, family: .bold)
        $0.numberOfLines = 0
        $0.textColor = UIColor.Text.primaryColor
        $0.textAlignment = .left
        $0.clipsToBounds = true
    }
    
    // 경기 결과를 감싸는 컨테이너
    private let gameInfoContainerView = UIView()
    
    // 경기 결과
    private let gameInfoLabel = UILabel().then {
        $0.text = "삼성 7 : 4 LG"
        $0.font = UIFont.pretendard(size: 22, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = UIColor.Text.secondaryColor
        $0.textAlignment = .left
        $0.clipsToBounds = true
    }
    
    // 메타 정보를 감싸는 컨테이너
    private let metaInfoContainerView = UIView()
    
    // 메타 정보(경기장 + 날짜 + 좌석)
    private let metaInfoLabel = UILabel().then {
        $0.text = "삼성라이온즈파크 | 1루 옐로우석"
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.numberOfLines = 1
        $0.textColor = UIColor.Text.tertiaryColor
        $0.textAlignment = .left
        $0.clipsToBounds = true
    }
    
    // 메모를 감싸는 컨테이너
    private let memoContainerView = UIView()
    
    // 메모
    private let memoLabel = UILabel().then {
        $0.text = "오늘 경기는 초반부터 긴장감이 대단했다. 1회 초에 선취점을 내줬을 때는 분위기가 조금 가라앉았지만, 바로 뒤이어 2회 말에 동점 홈런이 나오면서 응원석이 하나로 뒤집혔다. 잠실 특유의 함성 덕분인지 선수들도 점점 리듬을 찾는 느낌이었다. 중반에는 양 팀 선발 투수 모두 안정적으로 던지면서 투수전 양상으로 흘러갔는데, 그 덕분에 한구 한구에 더 집중할 수 있었다. 6회 말 중요한 찬스에서 적시타가 터지자 응원가가 끊이지 않았고, 그 순간이 오늘 직관의 하이라이트였던 것 같다."
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.setLineSpacing(spacing: 3)
        $0.numberOfLines = 0
        $0.textAlignment = .left
        $0.lineBreakStrategy = .hangulWordPriority
        $0.clipsToBounds = true
    }
    
    // 직관 날짜를 감싸는 컨테이너
    private let dateContainerView = UIView()
    
    // 메타 정보(경기장 + 날짜 + 좌석)
    private let dateInfoLabel = UILabel().then {
        $0.text = "2025년 07월 13일"
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 1
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
        scrollView.addSubview(stackView)
        titleContainerView.addSubview(titleLabel)
        gameInfoContainerView.addSubview(gameInfoLabel)
        metaInfoContainerView.addSubview(metaInfoLabel)
        memoContainerView.addSubview(memoLabel)
        dateContainerView.addSubview(dateInfoLabel)
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalTo(safeAreaLayoutGuide)
            make.bottom
                .equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.edges
                .equalTo(scrollView.contentLayoutGuide)
            make.width
                .equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.setCustomSpacing(30, after: thumbnailImageView)
        stackView.setCustomSpacing(5, after: gameInfoContainerView)
        
        thumbnailImageView.snp.makeConstraints { make in
            make.height
                .equalTo(thumbnailImageView.snp.width)
        }
        
        [titleLabel, gameInfoLabel, metaInfoLabel, memoLabel, dateInfoLabel].forEach {
            $0.snp.makeConstraints { make in
                make.top.bottom
                    .equalToSuperview()
                make.leading.trailing
                    .equalToSuperview()
                    .inset(16)
            }
        }
    }

}
