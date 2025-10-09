//
//  DiaryGameInfoInputViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/1/25.
//

import UIKit

// MARK: - 직관 일기 작성을 위한 게임 정보 입력을 담당하는 뷰 컨트롤러입니다.

final class DiaryGameInfoInputViewController: UIViewController {
    private let diaryGameInfoInputView = DiaryGameInfoInputView()
    
    override func loadView() {
        self.view = diaryGameInfoInputView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        configureNavigationBarItem()
    }
    
    /// 네비게이션 바 버튼 아이템을 설정합니다.
    private func configureNavigationBarItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "다음",
            style: .plain,
            target: self,
            action: #selector(nextButtonTapped)
        )
    }
}

extension DiaryGameInfoInputViewController {
    @objc private func nextButtonTapped() {
        
    }
}
