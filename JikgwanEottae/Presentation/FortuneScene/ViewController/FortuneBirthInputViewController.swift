//
//  FortuneBirthInputViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/10/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 오늘의 직관 운세를 확인하기 위한 생년월일 입력 뷰 컨트롤러입니다.

final class FortuneBirthInputViewController: UIViewController {
    private let fortuneBirthInputView = FortuneBirthInputView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = fortuneBirthInputView
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.fortuneBirthInputView.progressView.setProgress(0.9, animated: true)
        }
    }

}
