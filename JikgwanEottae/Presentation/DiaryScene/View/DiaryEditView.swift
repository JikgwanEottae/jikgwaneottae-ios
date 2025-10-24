//
//  DiaryEditView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 7/28/25.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class DiaryEditView: UIView {
    private(set) var closeBarButton = UIBarButtonItem().then {
        let config = UIImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
        $0.image = UIImage(systemName: "xmark", withConfiguration: config)
        $0.style = .plain
    }
    
    private(set) var editBarButton = UIBarButtonItem().then {
        $0.title = "수정하기"
        $0.style = .plain
        $0.setTitleTextAttributes([
            .font: UIFont.pretendard(size: 16, family: .semiBold),
            .foregroundColor: UIColor.Custom.orange
        ], for: .normal)
    }
    
    public let activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = UIColor.Custom.charcoal
    }
    
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = true
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
        $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
    }
    
    private lazy var stackView = UIStackView(
        arrangedSubviews:[
            titleTextField,
            seperateView,
            contentTextView,
            photoContainerView,
            favoriteTeamTextField,
            seatTextField,
        ]
    ).then {
        $0.layoutMargins = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 20
        $0.clipsToBounds = true
    }
    
    // 제목
    private(set) var titleTextField = UITextField().then {
        $0.placeholder = "제목을 입력해주세요"
        $0.setPlaceholder(color: UIColor.Text.placeholderColor)
        $0.font = UIFont.pretendard(size: 18, family: .semiBold)
        $0.textColor = UIColor.Text.secondaryColor
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.contentVerticalAlignment = .center
    }
    
    // 제목과 본문 구분선
    private let seperateView = UIView().then {
        $0.backgroundColor = UIColor.Background.borderColor
        $0.clipsToBounds = true
    }
    
    // 본문 메모 텍스트 뷰
    private(set) var contentTextView = UITextView().then {
        $0.text = Constants.Text.textViewPlaceholder
        $0.font = UIFont.pretendard(size: 16, family: .medium)
        $0.textColor = UIColor.Text.placeholderColor
        $0.textContainer.lineFragmentPadding = 0
        $0.clipsToBounds = true
    }
    
    // 응원팀
    private(set) lazy var favoriteTeamTextField = UnderlinedInputField(
        title: "응원팀",
        placeholder: "응원팀을 선택해주세요",
        inputView: nil
    )
    
    // 좌석
    private(set) var seatTextField = UnderlinedInputField(
        title: "좌석(선택사항)",
        placeholder: "좌석을 입력해주세요",
        inputView: nil
    )
    
    // 사진 가져오기 버튼 컨테이너 뷰
    private let photoContainerView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // 사진첩에서 사진 가져오기 버튼
    public let photoSelectionButton = UIButton(type: .custom).then {
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        let image = UIImage(systemName: "photo.stack")?
            .withConfiguration(symbolConfig)
            .withTintColor(.secondaryTextColor, renderingMode: .alwaysOriginal)
        $0.setImage(image, for: .normal)
        $0.contentHorizontalAlignment = .center
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = UIColor.Background.secondaryColor
        $0.layer.cornerRadius = 17
        $0.clipsToBounds = true
        $0.adjustsImageWhenHighlighted = false
    }
    
    // 업로드할 사진
    private(set) var imageView = UIImageView().then {
        $0.kf.indicatorType = .activity
        $0.contentMode = .scaleAspectFill
        $0.backgroundColor = UIColor.Background.secondaryColor
        $0.layer.cornerRadius = 17
        $0.clipsToBounds = true
        $0.isHidden = true
        $0.isUserInteractionEnabled = true
    }
    
    // 사진 삭제 버튼
    private(set) var removePhotoButton = UIButton(configuration: .plain()).then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark.circle.fill")
        config.baseForegroundColor = UIColor.Custom.orange
        config.contentInsets = .zero
        config.preferredSymbolConfigurationForImage = .init(pointSize: 20, weight: .semibold)
        $0.configuration = config
        $0.backgroundColor = UIColor.white
        $0.layer.cornerRadius = 11
        $0.clipsToBounds = true
        $0.isHidden = true
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
        addSubview(activityIndicator)
        scrollView.addSubview(stackView)
        photoContainerView.addSubview(photoSelectionButton)
        photoContainerView.addSubview(imageView)
        imageView.addSubview(removePhotoButton)
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
    }
    
    private func setupLayout() {
        activityIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalToSuperview()
            make.bottom
                .equalTo(keyboardLayoutGuide.snp.top)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges
                .equalTo(scrollView.contentLayoutGuide)
            make.width
                .equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.setCustomSpacing(10, after: titleTextField)
        stackView.setCustomSpacing(30, after: photoContainerView)
        stackView.setCustomSpacing(30, after: favoriteTeamTextField)
        
        seperateView.snp.makeConstraints { make in
            make.height
                .equalTo(1)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.height
                .equalTo(200)
        }
        
        photoSelectionButton.snp.makeConstraints { make in
            make.leading.top.bottom
                .equalToSuperview()
            make.size
                .equalTo(120)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading
                .equalTo(photoSelectionButton.snp.trailing)
                .offset(14)
            make.top.bottom
                .equalToSuperview()
            make.size
                .equalTo(120)
        }
        
        removePhotoButton.snp.makeConstraints { make in
            make.top.trailing
                .equalToSuperview()
                .inset(5)
            make.size
                .equalTo(22)
        }
    }
}

extension DiaryEditView {
    public func configureImage(with urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString)
        else {
            isHiddenImageView(true)
            return
        }
        imageView.kf.setImage(with: url)
        isHiddenImageView(false)
    }
    
    public func updateContentText(_ text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || trimmed == Constants.Text.textViewPlaceholder {
            contentTextView.textColor = UIColor.Text.placeholderColor
        } else {
            contentTextView.text = trimmed
            contentTextView.textColor = UIColor.Text.tertiaryColor
        }
    }
    
    public func didPickImage(_ image: UIImage) {
        updateImageView(with: image)
        isHiddenImageView(false)
    }
    
    public func removePhoto() {
        isHiddenImageView(true)
    }
    
    private func updateImageView(with image: UIImage) {
        imageView.image = image
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.Background.borderColor.cgColor
    }
    
    private func isHiddenImageView(_ isHidden: Bool) {
        imageView.isHidden = isHidden
        removePhotoButton.isHidden = isHidden
    }
    
    public func highlightFavoriteTeamField(_ isActive: Bool) {
        let color: UIColor = isActive ? UIColor.Custom.orange : UIColor.Background.primaryColor
        favoriteTeamTextField.setUnderlineColor(color)
    }
    
    public func highlightSeatField(_ isActive: Bool) {
        let color: UIColor = isActive ? UIColor.Custom.orange : UIColor.Background.primaryColor
        seatTextField.setUnderlineColor(color)
    }
}
