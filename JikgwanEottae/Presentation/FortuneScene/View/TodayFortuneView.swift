//
//  TodayFortuneView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/2/25.
//

import UIKit

import SnapKit
import Then

final class TodayFortuneView: UIView {
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    private lazy var stackView = UIStackView(arrangedSubviews: [
        titleLabel,
        subtitleLabel,
        birthInputField,
        timeInputField,
        sexInputField,
        kboTeamInputField,
    ]).then {
        $0.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.axis = .vertical
        $0.spacing = 50
        $0.clipsToBounds = true
    }
    // 타이틀 레이블
    private let titleLabel = UILabel().then {
        $0.text = "직관러를 위한 오늘의 직관 운세"
        $0.numberOfLines = 1
        $0.font = .gMarketSans(size: 20, family: .medium)
        $0.textColor = .primaryTextColor
    }
    // 서브 타이틀 레이블
    private let subtitleLabel = UILabel().then {
        $0.text = "점수를 확인하고 승리요정에 도전하세요"
        $0.numberOfLines = 1
        $0.font = .gMarketSans(size: 14, family: .medium)
        $0.textColor = .tertiaryTextColor
    }
    // 생년월일을 선택하는 데이트 피커입니다.
    public let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
        $0.maximumDate = Date()
        $0.clipsToBounds = true
        $0.backgroundColor = .white
    }
    // 시각을 선택하는 피커 뷰입니다.
    public let timePickerView = UIPickerView().then {
        $0.backgroundColor = .white
    }
    // 성별을 선택하는 피커 뷰입니다.
    public let sexPickerView = UIPickerView().then {
        $0.backgroundColor = .white
    }
    // 구단을 선택하는 피커 뷰입니다.
    public let kboTeamPickerView = UIPickerView().then {
        $0.backgroundColor = .white
    }
    // 생년월일 텍스트 필드입니다.
    public lazy var birthInputField = UnderlinedInputField(
        title: "생년월일",
        placeholder: "20250101",
        inputView: datePicker
    )
    // 시각 텍스트 필드입니다.
    public lazy var timeInputField = UnderlinedInputField(
        title: "시간(선택)",
        placeholder: "15",
        inputView: timePickerView
    )
    // 성별 텍스트 필드입니다.
    public lazy var sexInputField = UnderlinedInputField(
        title: "성별",
        placeholder: "선택해주세요",
        inputView: sexPickerView
    )
    // 구단 텍스트 필드입니다.
    public lazy var kboTeamInputField = UnderlinedInputField(
        title: "구단",
        placeholder: "선택해주세요",
        inputView: kboTeamPickerView
    )
    
    public let completeButton = UIButton(type: .custom).then {
        $0.setTitle("결과보기", for: .normal)
        $0.titleLabel?.font = .gMarketSans(size: 18, family: .medium)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .mainCharcoalColor
        $0.layer.cornerRadius = 17
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
        self.backgroundColor = .white
        self.addSubview(scrollView)
        self.scrollView.addSubview(stackView)
        self.addSubview(completeButton)
    }
    
    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing
                .equalToSuperview()
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
        stackView.setCustomSpacing(12, after: titleLabel)
        completeButton.snp.makeConstraints { make in
            make.bottom
                .equalTo(keyboardLayoutGuide.snp.top)
                .offset(-10)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.height
                .equalTo(Constants.buttonHeight)
        }
    }
}

extension TodayFortuneView {
    /// 툴바를 생성합니다.
    private func createToolBar(target: Any?, action: Selector) -> UIToolbar {
        let toolbar = UIToolbar().then {
            $0.sizeToFit()
            $0.backgroundColor = .white
        }
        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        let confirmButton = UIBarButtonItem(
            title: "확인",
            style: .done,
            target: target,
            action: action
        ).then {
            $0.setTitleTextAttributes([
                .font: UIFont.gMarketSans(size: 15, family: .medium),
                .foregroundColor: UIColor.primaryTextColor
            ], for: .normal)
        }
        toolbar.setItems([flexSpace, confirmButton], animated: false)
        return toolbar
    }
    /// 툴바를 적용합니다.
    public func setupToolBar(target: Any?, action: Selector) {
        let toolbar = createToolBar(target: target, action: action)
        birthInputField.textField.inputAccessoryView = toolbar
        timeInputField.textField.inputAccessoryView = toolbar
        sexInputField.textField.inputAccessoryView = toolbar
        kboTeamInputField.textField.inputAccessoryView = toolbar
    }
}
