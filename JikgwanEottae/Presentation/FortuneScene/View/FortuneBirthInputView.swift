//
//  FortuneBirthInputView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/10/25.
//

import UIKit

import SnapKit
import Then

final class FortuneBirthInputView: UIView {
    private(set) var activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = UIColor.Custom.charcoal
    }
    
    // 진행 상태 프로그레스 뷰입니다.
    public var progressView = UIProgressView(progressViewStyle: .default).then {
        $0.progressTintColor = UIColor.Custom.blue
        $0.trackTintColor = UIColor.Background.primaryColor
        $0.layer.cornerRadius = 3
        $0.clipsToBounds = true
        $0.setProgress(0.6, animated: false)
    }
    
    // 타이틀 레이블입니다.
    private let titleLabel = UILabel().then {
        $0.text = "생년월일을 알려주세요"
        $0.font = UIFont.pretendard(size: 22, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    // 서브 타이틀입니다.
    private let subtitleLabel = UILabel().then {
        $0.text = "출생 시는 선택이지만 운세가 더 정확해져요"
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.textAlignment = .left
        $0.numberOfLines = 1
    }
    
    // 생년월일 텍스트 필드입니다.
    public lazy var birthInputField = UnderlinedInputField(
        title: "생년월일",
        placeholder: "생년월일을 선택해주세요",
        inputView: datePicker
    )
    
    // 생년월일을 선택하는 데이트 피커입니다.
    public let datePicker = UIDatePicker().then {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .wheels
        $0.locale = Locale(identifier: "ko_KR")
        $0.maximumDate = Date()
        $0.clipsToBounds = true
        $0.backgroundColor = UIColor.Background.primaryColor
    }
    
    // 출생 시 텍스트 필드입니다.
    private(set) lazy var timeInputField = UnderlinedInputField(
        title: "출생 시(선택사항)",
        placeholder: "출생 시를 선택해주세요",
        inputView: timePickerView
    )
    
    // 출생 시를 선택하는 피커 뷰입니다.
    public let timePickerView = UIPickerView().then {
        $0.backgroundColor = UIColor.Background.primaryColor
    }
    
    // 오늘의 직관 운세 결과보기 버튼입니다.
    private(set) var completeButton = UIButton(type: .custom).then {
        $0.setTitle("결과보기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(size: 18, family: .semiBold)
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor.Custom.blue
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
        backgroundColor = UIColor.white
        self.addSubview(progressView)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(birthInputField)
        self.addSubview(timeInputField)
        self.addSubview(completeButton)
        self.addSubview(activityIndicator)
    }
    
    private func setupLayout() {
        progressView.snp.makeConstraints { make in
            make.top
                .equalTo(safeAreaLayoutGuide)
                .offset(20)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.height
                .equalTo(8)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top
                .equalTo(progressView.snp.bottom)
                .offset(40)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.top
                .equalTo(titleLabel.snp.bottom)
                .offset(12)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        birthInputField.snp.makeConstraints { make in
            make.top
                .equalTo(subtitleLabel.snp.bottom)
                .offset(40)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        timeInputField.snp.makeConstraints { make in
            make.top
                .equalTo(birthInputField.snp.bottom)
                .offset(40)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        activityIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
        
        completeButton.snp.makeConstraints { make in
            make.bottom
                .equalTo(keyboardLayoutGuide.snp.top)
                .offset(-10)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.height
                .equalTo(Constants.Button.height)
        }
    }
}

extension FortuneBirthInputView {
    /// 생년월일 텍스트 필드를 업데이트합니다.
    public func updateBirth(_ text: String) {
        birthInputField.textField.text = text
        birthInputField.textField.sendActions(for: .valueChanged)
    }
    
    /// 출생 시 텍스트 필드를 업데이트합니다.
    public func updateTime(_ text: String) {
        timeInputField.textField.text = text
        timeInputField.textField.sendActions(for: .valueChanged)
    }
}
