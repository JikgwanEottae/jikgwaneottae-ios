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
    private let viewModel: FortuneGenderSelectionViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: FortuneGenderSelectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = fortuneGenderSelectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackBarButtonItem()
        bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.fortuneGenderSelectionView.progressView.setProgress(0.6, animated: true)
        }
    }
    
    private func bindViewModel() {
        let input = FortuneGenderSelectionViewModel.Input(
            maleButtonTapped: fortuneGenderSelectionView.maleButton.rx.tap
                .asObservable(),
            femaleButtonTapped: fortuneGenderSelectionView.femaleButton.rx.tap
                .asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.inputData
            .withUnretained(self)
            .subscribe(onNext: { owner, inputData in
                owner.navigateToBirthInput(
                    favoriteTeam: inputData.0,
                    gender: inputData.1
                )
            })
            .disposed(by: disposeBag)
    }
}

extension FortuneGenderSelectionViewController {
    // 생년월일 입력 화면으로 이동합니다.
    private func navigateToBirthInput(favoriteTeam: String, gender: String) {
        let repository = TodayFortuneRepository(networkManager: TodayFortuneNetworkManager.shared)
        let useCase = TodayFortuneUseCase(repository: repository)
        let viewModel = FortuneBirthInputViewModel(
            favoriteTeam: favoriteTeam,
            gender: gender,
            useCase: useCase
        )
        let fortuneBirthInputViewController = FortuneBirthInputViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(fortuneBirthInputViewController, animated: false)
    }
}
