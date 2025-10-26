//
//  FavoriteTeamEditView.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/27/25.
//

import UIKit

import SnapKit
import Then

// MARK: - 사용자의 응원 구단을 설정하기 위한 뷰입니다.

final class FavoriteTeamEditView: UIView {
    public let activityIndicator = UIActivityIndicatorView().then {
        $0.style = .medium
        $0.hidesWhenStopped = true
        $0.color = UIColor.Custom.charcoal
    }
    
    private(set) var titleLabel = UILabel().then {
        $0.text = "응원팀을 선택해주세요"
        $0.numberOfLines = 0
        $0.font = UIFont.pretendard(size: 22, family: .semiBold)
        $0.textColor = UIColor.Text.primaryColor
    }
    
    private(set) var subtitleLabel = UILabel().then {
        $0.text = "선택에 따라 응원 캐릭터도 달라져요"
        $0.font = UIFont.pretendard(size: 14, family: .medium)
        $0.textColor = UIColor.Text.tertiaryColor
        $0.numberOfLines = 1
    }
    
    private(set) var favoriteTeamInputField = UnderlinedInputField(
        title: "응원팀",
        placeholder: "응원팀을 선택해주세요",
        inputView: nil
    )
    
    private(set) var completeButton = UIButton(type: .custom).then {
        $0.setTitle("수정하기", for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(size: 18, family: .semiBold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor.Custom.blue
        $0.layer.cornerRadius = 17
        $0.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupLayout()
        loadFavoriteTeam()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
        self.addSubview(activityIndicator)
        self.addSubview(titleLabel)
        self.addSubview(subtitleLabel)
        self.addSubview(favoriteTeamInputField)
        self.addSubview(completeButton)
    }
    
    private func setupLayout() {
        activityIndicator.snp.makeConstraints { make in
            make.center
                .equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top
                .equalTo(safeAreaLayoutGuide)
                .offset(20)
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
        
        favoriteTeamInputField.snp.makeConstraints { make in
            make.top
                .equalTo(subtitleLabel.snp.bottom)
                .offset(50)
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing
                .equalToSuperview()
                .inset(20)
            make.bottom
                .equalTo(keyboardLayoutGuide.snp.top)
                .offset(-10)
            make.height
                .equalTo(Constants.Button.height)
        }
    }
}

extension FavoriteTeamEditView {
    private func loadFavoriteTeam() {
        guard let favoriteTeam = UserDefaultsManager.shared.favoriteTeam,
              let team = KBOTeam.allCases.first(where: { "\($0)" == favoriteTeam }) else {
            return
        }
        favoriteTeamInputField.textField.text = team.rawValue
    }
    
    public func highlightFavoriteTeamField(_ isActive: Bool) {
        let color: UIColor = isActive ? UIColor.Custom.blue : UIColor.Background.primaryColor
        favoriteTeamInputField.setUnderlineColor(color)
    }
}
