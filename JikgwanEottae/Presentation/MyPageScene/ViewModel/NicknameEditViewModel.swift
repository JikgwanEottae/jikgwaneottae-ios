//
//  NicknameEditViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/6/25.
//

import Foundation

import RxSwift
import RxCocoa

final class NicknameEditViewModel: ViewModelType {
    private let useCase: AuthUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    struct Input {
        let nickname: Observable<String>
        let completeButtonTapped: Observable<Void>
    }
    
    struct Output {
        let isButtonEnabled: Observable<Bool>
        let isLoading: Driver<Bool>
        let success: Signal<Void>
        let error: Signal<Void>
        let validation: Driver<Bool>
    }
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
    
    
    public func transform(input: Input) -> Output {
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        let successRelay = PublishRelay<Void>()
        let errorRelay = PublishRelay<Void>()
        let isNoticeHiddenRelay = BehaviorRelay<Bool>(value: true)
        
        let isButtonEnable = input.nickname
            .map { $0.count >= 2 }
            .startWith(false)
        
        input.nickname
            .withUnretained(self)
            .subscribe(onNext: { owner, nickname in
                if !nickname.isEmpty {
                    isNoticeHiddenRelay.accept(owner.validateNickname(nickname))
                } else {
                    isNoticeHiddenRelay.accept(true)
                }
            })
            .disposed(by: disposeBag)
        
        input.completeButtonTapped
            .withLatestFrom(input.nickname)
            .filter{ _ in isNoticeHiddenRelay.value }
            .withUnretained(self)
            .flatMap { owner, nickname -> Observable<Void> in
                return owner.useCase.setProfileNickname(nickname)
                    .andThen(Observable.just(()))
                    .catch { error in
                        errorRelay.accept(())
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: {
                successRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            isButtonEnabled: isButtonEnable,
            isLoading: isLoadingRelay.asDriver(),
            success: successRelay.asSignal(),
            error: errorRelay.asSignal(),
            validation: isNoticeHiddenRelay.asDriver()
            
        )
    }
}

extension NicknameEditViewModel {
    private func validateNickname(_ nickname: String) -> Bool {
        let regex = "^[가-힣a-zA-Z0-9]{2,10}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: nickname)
    }
}
