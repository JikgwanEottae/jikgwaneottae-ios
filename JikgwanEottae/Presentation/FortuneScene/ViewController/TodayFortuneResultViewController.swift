//
//  TodayFortuneResultViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/2/25.
//

import UIKit

import RxSwift
import RxCocoa

final class TodayFortuneResultViewController: UIViewController {
    private let todayFortuneResultView = TodayFortuneResultView()
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = todayFortuneResultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButtonTapped()
    }
    
    private func closeButtonTapped() {
        todayFortuneResultView.completeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }

}
