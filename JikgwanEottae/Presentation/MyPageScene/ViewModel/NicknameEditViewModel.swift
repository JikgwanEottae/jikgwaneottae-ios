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
        let success: Observable<Void>
        let error: Observable<Error>
        let validation: Driver<Bool>
    }
    
    init(useCase: AuthUseCaseProtocol) {
        self.useCase = useCase
    }
    
    
    public func transform(input: Input) -> Output {
        let isLoadingRelay = BehaviorRelay<Bool>(value: false)
        let successRelay = PublishRelay<Void>()
        let errorRelay = PublishRelay<Error>()
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
            .flatMapLatest { owner, nickname in
                isLoadingRelay.accept(true)
                return owner.useCase.setProfileNickname(nickname)
                    .do(onError: { error in
                        errorRelay.accept(error)
                        isLoadingRelay.accept(false)
                    }, onCompleted: { 
                        successRelay.accept(())
                        isLoadingRelay.accept(false)
                    })
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        return Output(
            isButtonEnabled: isButtonEnable,
            isLoading: isLoadingRelay.asDriver(),
            success: successRelay.asObservable(),
            error: errorRelay.asObservable(),
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
