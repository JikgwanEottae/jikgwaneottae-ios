//
//  PrivacyPolicyViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/8/25.
//

import UIKit

import SnapKit
import MarkdownKit
import Then

// MARK: - 개인정보 처리방침을 표시하기 위한 뷰 컨트롤러입니다.

final class PrivacyPolicyViewController: UIViewController {
    private let textView = UITextView().then {
        $0.isEditable = false
        $0.isSelectable = true
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .white
        $0.textColor = .primaryTextColor
        $0.font = .gMarketSans(size: 14, family: .medium)
        $0.textAlignment = .left
        $0.contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        loadPrivacyPolicy()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        self.view.addSubview(textView)
    }
    
    private func setupLayout() {
        textView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
    /// 이용약관 마크다운 파일을 불러옵니다.
    private func loadPrivacyPolicy() {
        guard let path = Bundle.main.path(forResource: "privacy_policy", ofType: "md"),
              let content = try? String(contentsOfFile: path) else { return }
        textView.attributedText = MarkdownParser().parse(content)
    }
}
