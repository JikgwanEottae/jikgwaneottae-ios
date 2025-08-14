//
//  RecordDetailInputView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/28/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class DiaryEditView: UIView {
    static let memoTextViewPlaceholderText = "직관 후기를 작성해보세요"
    
    // 편집모드에서 직관 일기를 삭제하기 위한 바 버튼 아이템입니다.
    public let deleteDiaryBarButtonItem = UIBarButtonItem(
        title: "삭제",
        style: .plain,
        target: nil,
        action: nil).then {
            let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.gMarketSans(size: 17, family: .medium)]
            $0.setTitleTextAttributes(attrs, for: .normal)
            $0.setTitleTextAttributes(attrs, for: .highlighted)
            $0.setTitleTextAttributes(attrs, for: .disabled)
            $0.tintColor = .tossRedColor
        }
    
    // 로딩 인디케이터입니다.
    public let activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = .mainCharcoalColor
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private lazy var stackView = UIStackView(
        arrangedSubviews:[
            photoSelectionButtonContainerView,
            supportTeamContainerView,
            seatInputFieldView,
            reviewContainerView
        ]
    ).then {
        $0.layoutMargins = UIEdgeInsets(
            top: 0,
            left: 20,
            bottom: 10,
            right: 20
        )
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 35
        $0.clipsToBounds = true
    }
    
    private let photoSelectionButtonContainerView = UIView().then {
        $0.clipsToBounds = true
    }
    
    // 업로드할 사진을 선택하기 위한 버튼입니다.
    public let selectPhotoButton = UIButton(type: .custom).then {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 27, weight: .medium)
        let image = UIImage(systemName: "photo.stack")?
            .withConfiguration(symbolConfig)
            .withTintColor(.secondaryTextColor, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.contentVerticalAlignment = .center
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .secondaryBackgroundColor
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.borderColor.cgColor
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.clipsToBounds = true
        $0.adjustsImageWhenHighlighted = false
    }
    
    // 업로드할 사진을 제거하기 위한 버튼입니다.
    public let removePhotoButton = UIButton(type: .custom).then {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .light)
        let image = UIImage(named: "xMark")?
            .withConfiguration(symbolConfig)
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .mainCharcoalColor
        $0.clipsToBounds = true
        $0.adjustsImageWhenHighlighted = false
        $0.layer.cornerRadius = 13
        $0.isHidden = true
    }
    
    private let supportTeamContainerView = UIView()
    
    private let supportTeamTitleLabel = UILabel().then {
        $0.text = "응원팀"
        $0.font = .gMarketSans(size: 14, family: .medium)
        $0.textColor = .primaryTextColor
    }

    public let teamSegmentControl = TeamSegmentedControl()
    
    public let seatInputFieldView = LabeledInputFieldView(
        title: "좌석",
        placeholder: "1루 테이블석 3구역"
    )
    
    private let reviewContainerView = UIView()
    
    private let reviewTitleLabel = UILabel().then {
        $0.text = "후기"
        $0.font = .gMarketSans(size: 14, family: .medium)
        $0.textColor = .primaryTextColor
    }
    
    public let memoTextView = UITextView().then {
        $0.text = memoTextViewPlaceholderText
        $0.font = .gMarketSans(size: 15, family: .medium)
        $0.textColor = .placeholderText
        $0.backgroundColor = .secondaryBackgroundColor
        $0.layer.cornerRadius = 15
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.borderColor.cgColor
        $0.clipsToBounds = true
        $0.showsVerticalScrollIndicator = false
        $0.textContainer.lineFragmentPadding = 0
        $0.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    public let createButton = UIButton(type: .custom).then {
        $0.setTitle("기록하기", for: .normal)
        $0.titleLabel?.font = .gMarketSans(size: 18, family: .medium)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainCharcoalColor
        $0.layer.cornerRadius = 17
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupUI()
        setupLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        addSubview(createButton)
        addSubview(activityIndicator)
        scrollView.addSubview(stackView)
        photoSelectionButtonContainerView.addSubview(selectPhotoButton)
        selectPhotoButton.addSubview(removePhotoButton)
        supportTeamContainerView.addSubview(supportTeamTitleLabel)
        supportTeamContainerView.addSubview(teamSegmentControl)
        reviewContainerView.addSubview(reviewTitleLabel)
        reviewContainerView.addSubview(memoTextView)
    }
    
    private func setupUI() {
        self.backgroundColor = .white
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.top
                .equalTo(safeAreaLayoutGuide)
            make.leading.trailing
                .equalToSuperview()
            make.bottom
                .equalTo(createButton.snp.top)
                .offset(-10)
        }
        stackView.snp.makeConstraints { make in
            make.edges
                .equalTo(scrollView.contentLayoutGuide)
            make.width
                .equalTo(scrollView.frameLayoutGuide)
        }
        photoSelectionButtonContainerView.snp.makeConstraints { make in
            make.height
                .equalTo(photoSelectionButtonContainerView.snp.width)
        }
        removePhotoButton.snp.makeConstraints { make in
            make.top.trailing
                .equalToSuperview().inset(10)
            make.size
                .equalTo(26)
        }
        selectPhotoButton.snp.makeConstraints { make in
            make.top.bottom
                .equalToSuperview()
                .inset(25)
            make.leading.trailing
                .equalToSuperview()
                .inset(25)
        }
        stackView.setCustomSpacing(20, after: photoSelectionButtonContainerView)
        supportTeamTitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        supportTeamTitleLabel.snp.makeConstraints { make in
            make.leading.centerY
                .equalToSuperview()
        }
        teamSegmentControl.snp.makeConstraints { make in
            make.leading
                .equalTo(supportTeamTitleLabel.snp.trailing)
                .offset(80)
            make.top.bottom.trailing.centerY
                .equalToSuperview()
            make.height
                .equalTo(50)
        }
        
        reviewTitleLabel.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalToSuperview()
        }
        memoTextView.snp.makeConstraints { make in
            make.top
                .equalTo(reviewTitleLabel.snp.bottom)
                .offset(10)
            make.leading.trailing.bottom
                .equalToSuperview()
            make.height
                .equalTo(200)
        }
        createButton.snp.makeConstraints { make in
            make.bottom
                .equalTo(keyboardLayoutGuide.snp.top)
                .offset(-10)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.height
                .equalTo(Constants.buttonHeight)
        }
        activityIndicator.snp.makeConstraints { make in
            make.centerX.centerY
                .equalToSuperview()
        }
    }
}

extension DiaryEditView {
    /// PHPicker로 사진이 선택됬을 때 해당 사진으로 교체합니다.
    public func didPickPhoto(_ image: UIImage) {
        selectPhotoButton.setImage(image, for: .normal)
        setFillPhoto()
    }
    
    /// 저장된 사진이 있다면 초기에 보여줄 사진으로 설정합니다.
    public func configurePhoto(_ imageURL: String) {
        guard let url = URL(string: imageURL) else { return }
        selectPhotoButton.kf.setImage(with: url, for: .normal)
        setFillPhoto()
        removePhotoButton.isHidden = false
    }
    
    /// 직관 후기 텍스트 작성 여부에 따른 메모 텍스트 뷰를 설정합니다.
    public func configureMemoText(_ text: String?) {
        if let text = text {
            memoTextView.text = text
            memoTextView.textColor = .primaryTextColor
        } else {
            memoTextView.text = DiaryEditView.memoTextViewPlaceholderText
            memoTextView.textColor = .placeholderText
        }
    }
    
    /// 선택된 사진을 제거하기 위해 기본 사진으로 대체합니다.
    public func removePhoto() {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 27, weight: .medium)
        let image = UIImage(systemName: "photo.stack")?
            .withConfiguration(symbolConfig)
            .withTintColor(.secondaryTextColor, renderingMode: .alwaysOriginal)
        selectPhotoButton.setImage(image, for: .normal)
        setFitPhoto()
        removePhotoButton.isHidden = true
    }
}

extension DiaryEditView {
    /// 사진이 선택된 후의 레이아웃을 설정합니다.
    private func setFillPhoto() {
        selectPhotoButton.contentHorizontalAlignment = .fill
        selectPhotoButton.contentVerticalAlignment   = .fill
        selectPhotoButton.contentMode = .scaleAspectFill
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
    }
    
    /// 사진이 제거된 후의 레이아웃을 설정합니다.
    private func setFitPhoto() {
        selectPhotoButton.contentHorizontalAlignment = .center
        selectPhotoButton.contentVerticalAlignment = .center
        selectPhotoButton.contentMode = .scaleAspectFit
        selectPhotoButton.imageView?.contentMode = .scaleAspectFit
    }
}
