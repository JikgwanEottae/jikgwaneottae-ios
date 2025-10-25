//
//  FortuneResultViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/2/25.
//

import UIKit

import RxSwift
import RxCocoa

// MARK: - 오늘의 직관 운세 결과 뷰 컨트롤러입니다.

final class FortuneResultViewController: UIViewController {
    private let fortuneResultView = FortuneResultView()
    private let viewModel: FortuneResultViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: FortuneResultViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = fortuneResultView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        closeButtonTapped()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let input = FortuneResultViewModel.Input()
        
        let output = self.viewModel.transform(input: input)
        
        output.fortune
            .drive(onNext: { [weak self] fortune in
                guard let self = self else {return }
                self.fortuneResultView.configure(with: fortune)
            })
            .disposed(by: disposeBag)
    }
    
    private func closeButtonTapped() {
        fortuneResultView.completeButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                owner.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
