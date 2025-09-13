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
    private lazy var todayFortuneResultView = TodayFortuneResultView()
    private let fortuneData: Fortune
    private let disposeBag = DisposeBag()

    init(fortune: Fortune) {
        self.fortuneData = fortune
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = todayFortuneResultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButtonTapped()
        todayFortuneResultView.configure(with: fortuneData)
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
