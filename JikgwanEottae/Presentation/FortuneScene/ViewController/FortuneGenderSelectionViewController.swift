//
//  FortuneGenderSelectionViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/10/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 오늘의 직관 운세를 확인하기 위한 성별 선택 뷰 컨트롤러입니다.

final class FortuneGenderSelectionViewController: UIViewController {
    private let fortuneGenderSelectionView = FortuneGenderSelectionView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = fortuneGenderSelectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindGenderButton()
        hideBackBarButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.fortuneGenderSelectionView.progressView.setProgress(0.6, animated: true)
        }
    }
    
    // 성별 선택 버튼을 바인드합니다.
    private func bindGenderButton() {
        fortuneGenderSelectionView.maleButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigateToBirthInput()
            })
            .disposed(by: disposeBag)
        
        fortuneGenderSelectionView.femaleButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.navigateToBirthInput()
            })
            .disposed(by: disposeBag)
    }
    
    // 생년월일 입력 화면으로 이동합니다.
    private func navigateToBirthInput() {
        let fortuneBirthInputViewController = FortuneBirthInputViewController()
        self.navigationController?.pushViewController(fortuneBirthInputViewController, animated: false)
    }
}
