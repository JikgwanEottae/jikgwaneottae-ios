//
//  SplashViewController.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/9/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

// MARK: - 스플래시 화면을 담당하는 뷰 컨트롤러입니다.

final class SplashViewController: UIViewController {
    private let splashImageView = UIImageView().then {
        $0.image = UIImage(named: "appImage")
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    private let viewModel: SplahViewModel
    private let viewDidLoadRelay = PublishRelay<Void>()
    private let disposeBag = DisposeBag()
    
    init(viewModel: SplahViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLayout()
        bindViewModel()
        viewDidLoadRelay.accept(())
    }
    
    private func setupUI() {
        self.view.backgroundColor = UIColor.black
        self.view.addSubview(splashImageView)
    }
    
    private func setupLayout() {
        splashImageView.snp.makeConstraints { make in
            make.edges
                .equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        let input = SplahViewModel.Input(viewDidLoad: viewDidLoadRelay.asObservable())
        let output = viewModel.transform(input: input)
        
        // 메인 화면으로 이동합니다.
        output.navigateToMain
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in
                let mainTabBarController = MainTabBarController()
                owner.transitionRoot(to: mainTabBarController)
            })
            .disposed(by: disposeBag)
    }
    
    private func transitionRoot(to viewController: UIViewController) {
        if let scene = self.view.window?.windowScene ?? UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelate = scene.delegate as? SceneDelegate {
            sceneDelate.changeRootViewController(to: viewController)
        }
    }
}
