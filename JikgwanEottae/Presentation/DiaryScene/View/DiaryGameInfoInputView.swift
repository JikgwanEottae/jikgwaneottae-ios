//
//  DiaryGameInfoInputView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/1/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 직관 일기 작성을 위한 게임 정보 입력을 담당하는 뷰입니다.

final class DiaryGameInfoInputView: UIView {
    
    private let titleLabel = UILabel().then {
        $0.text = "응원팀과 좌석을 알려주세요"
        $0.font = UIFont.pretendard(size: 20, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
        $0.setLineSpacing(spacing: 5)
        $0.numberOfLines = 0
    }
    
    private(set) var favoriteTeamTextField = UnderlinedInputField(
        title: "응원팀",
        placeholder: "응원팀을 선택해주세요",
        inputView: nil
    )
    
    private(set) var seatTextField = UnderlinedInputField(
        title: "좌석(선택사항)",
        placeholder: "좌석을 입력해주세요",
        inputView: nil
    )
    
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
        self.addSubview(titleLabel)
        self.addSubview(favoriteTeamTextField)
        self.addSubview(seatTextField)
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
    }
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
                .offset(20)
            make.leading.trailing
                .equalToSuperview()
                .inset(12)
        }
        
        favoriteTeamTextField.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
                .offset(40)
            make.leading.trailing
                .equalToSuperview()
                .inset(12)
        }
        
        seatTextField.snp.makeConstraints { make in
            make.top.equalTo(favoriteTeamTextField.snp.bottom)
                .offset(40)
            make.leading.trailing
                .equalToSuperview()
                .inset(12)
        }
    }
}
