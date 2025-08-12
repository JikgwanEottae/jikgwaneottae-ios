//
//  RecordDetailInputView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/28/25.
//

import UIKit

import SnapKit
import Then

final class DiaryEditView: UIView {
    static let memoTextViewPlaceholderText = "직관 후기를 작성해보세요"
    
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
    
    public let selectPhotoButton = UIButton(type: .custom).then {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 27, weight: .medium)
        let image = UIImage(systemName: "photo.stack")?
            .withConfiguration(symbolConfig)
            .withTintColor(.secondaryTextColor, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = Constants.cornerRadius
        $0.clipsToBounds = true
        $0.adjustsImageWhenHighlighted = false
    }
    
    public let removePhotoButton = UIButton(type: .custom).then {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 10, weight: .light)
        let image = UIImage(named: "xMark")?
            .withConfiguration(symbolConfig)
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .mainCharcoalColor
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.adjustsImageWhenHighlighted = false
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setDashedBorder()
    }
    
    private func addSubviews() {
        addSubview(scrollView)
        addSubview(createButton)
        addSubview(activityIndicator)
        scrollView.addSubview(stackView)
        photoSelectionButtonContainerView.addSubview(selectPhotoButton)
        photoSelectionButtonContainerView.addSubview(removePhotoButton)
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
                .equalToSuperview()
            make.size
                .equalTo(24)
        }
        selectPhotoButton.snp.makeConstraints { make in
            make.top.bottom
                .equalToSuperview()
                .inset(20)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
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
    
    public func didPickImage(_ image: UIImage) {
        selectPhotoButton.setImage(image, for: .normal)
        selectPhotoButton.contentHorizontalAlignment = .fill
        selectPhotoButton.contentVerticalAlignment   = .fill
        selectPhotoButton.contentMode = .scaleAspectFill
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        // 점선 레이어 제거
        selectPhotoButton.layer.sublayers?
            .filter { $0.name == "dashedBorder" }
            .forEach { $0.removeFromSuperlayer() }
    }
    
    public func configureImage(_ imageURL: String) {
        
        selectPhotoButton.contentHorizontalAlignment = .fill
        selectPhotoButton.contentVerticalAlignment   = .fill
        selectPhotoButton.contentMode = .scaleAspectFill
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        // 점선 레이어 제거
        selectPhotoButton.layer.sublayers?
            .filter { $0.name == "dashedBorder" }
            .forEach { $0.removeFromSuperlayer() }
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
    
    public func removePhoto() {
        print("remove")
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 27, weight: .medium)
        let image = UIImage(systemName: "photo.stack")?
            .withConfiguration(symbolConfig)
            .withTintColor(.secondaryTextColor, renderingMode: .alwaysOriginal)
        selectPhotoButton.setImage(image, for: .normal)
        selectPhotoButton.contentHorizontalAlignment = .center
        selectPhotoButton.contentVerticalAlignment = .center
        selectPhotoButton.contentMode = .scaleAspectFit
        selectPhotoButton.imageView?.contentMode = .scaleAspectFit
        removePhotoButton.isHidden = true
        setDashedBorder()
    }
    
    public func setDashedBorder() {
        selectPhotoButton.layer.sublayers?
            .filter { $0.name == "dashedBorder" }
            .forEach { $0.removeFromSuperlayer() }

      let borderLayer = CAShapeLayer()
      borderLayer.name = "dashedBorder"
      borderLayer.strokeColor = UIColor.dottedBorderColor.cgColor
      borderLayer.lineDashPattern = [5, 5]
      borderLayer.lineWidth = 2.5
      borderLayer.fillColor = nil
      borderLayer.frame = selectPhotoButton.bounds
      borderLayer.path = UIBezierPath(
        roundedRect: selectPhotoButton.bounds,
        cornerRadius: Constants.cornerRadius
      ).cgPath
        selectPhotoButton.layer.addSublayer(borderLayer)
    }
    
}


