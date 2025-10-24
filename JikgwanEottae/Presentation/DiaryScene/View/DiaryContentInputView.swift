//
//  DiaryContentInputView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/19/25.
//

import UIKit

import SnapKit
import Then

final class DiaryContentInputView: UIView {
    private(set) var activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = UIColor.Custom.charcoal
    }
    
    // 스크롤 뷰
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    // 스택 뷰
    private lazy var stackView = UIStackView(
        arrangedSubviews: [
            titleTextField,
            seperateView,
            memoTextView,
            photoContainerView
        ]
    ).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 14, bottom: 0, right: 14)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.alignment = .fill
        $0.spacing = 20
        $0.clipsToBounds = true
    }
    
    // 제목 텍스트 필드
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
    private(set) var memoTextView = UITextView().then {
        $0.text = Constants.Text.textViewPlaceholder
        $0.font = UIFont.pretendard(size: 16, family: .medium)
        $0.textColor = UIColor.Text.placeholderColor
        $0.textContainer.lineFragmentPadding = 0
        $0.clipsToBounds = true
    }
    
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
    
    // 작성 버튼
    private(set) var completeButton = UIButton(type: .custom).then {
        $0.setTitle("작성하기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(size: 18, family: .medium)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor.Custom.orange
        $0.layer.cornerRadius = 17
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setupUI()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubViews() {
        addSubview(activityIndicator)
        addSubview(scrollView)
        addSubview(completeButton)
        scrollView.addSubview(stackView)
        photoContainerView.addSubview(photoSelectionButton)
        photoContainerView.addSubview(imageView)
        imageView.addSubview(removePhotoButton)
    }
    
    private func setupUI() {
        backgroundColor = .white
    }
    
    private func setupLayout() {
        activityIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalTo(safeAreaLayoutGuide)
            make.bottom
                .equalTo(completeButton.snp.top)
                .offset(-10)
        }
        
        stackView.snp.makeConstraints { make in
            make.edges
                .equalTo(scrollView.contentLayoutGuide)
            make.width
                .equalTo(scrollView.frameLayoutGuide)
        }
        
        stackView.setCustomSpacing(10, after: titleTextField)
        
        seperateView.snp.makeConstraints { make in
            make.height
                .equalTo(1)
        }
        
        memoTextView.snp.makeConstraints { make in
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
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(14)
            make.bottom
                .equalTo(keyboardLayoutGuide.snp.top)
                .offset(-10)
            make.height
                .equalTo(Constants.Button.height)
        }
    }
}

extension DiaryContentInputView {
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
}
