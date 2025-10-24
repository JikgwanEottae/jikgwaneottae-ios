//
//  DiaryContentInputViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/21/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DiaryContentInputViewModel {
    private let gameId: Int
    private let favoriteTeam: String
    private let seat: String
    private let useCase: DiaryUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    struct Input {
        let title: Observable<String>
        let content: Observable<String>
        let photo: Observable<Data?>
        let submitButtonTapped: Observable<Void>
    }
    
    struct Output {
        let showEmptyAlert: Signal<Void>
        let createSuccess: Signal<Void>
        let createFailure: Signal<Void>
        let isLoading: Driver<Bool>
    }
    
    init(
        gameId: Int,
        favoriteTeam: String,
        seat: String,
        useCase: DiaryUseCaseProtocol
    ) {
        self.gameId = gameId
        self.favoriteTeam = favoriteTeam
        self.seat = seat
        self.useCase = useCase
    }
    
    public func transform(input: Input) -> Output {
        let showEmptyAlert = PublishRelay<Void>()
        let success = PublishRelay<Void>()
        let failure = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        
        input.submitButtonTapped
            .withLatestFrom(Observable.combineLatest(
                input.title,
                input.content,
                input.photo
            ))
            .flatMapLatest { [weak self] (title, content, photoData) -> Observable<Void> in
                guard let self = self else { return .empty() }
                let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                let cleanedContent = self.cleanContent(content)
                if trimmedTitle.isEmpty {
                    showEmptyAlert.accept(())
                    return .empty()
                }
                isLoading.accept(true)
                return useCase.createDiary(
                    gameID: gameId,
                    title: trimmedTitle,
                    favoriteTeam: favoriteTeam,
                    seat: seat,
                    content: cleanedContent,
                    photoData: photoData
                )
                .andThen(Observable.just(()))
            }
            .subscribe(onNext: {
                isLoading.accept(false)
                success.accept(())
            }, onError: { error in
                isLoading.accept(false)
                failure.accept(())
            })
            .disposed(by: disposeBag)

        return Output(
            showEmptyAlert: showEmptyAlert.asSignal(),
            createSuccess: success.asSignal(),
            createFailure: failure.asSignal(),
            isLoading: isLoading.asDriver()
        )
    }
    
    private func cleanContent(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty || trimmed == Constants.Text.textViewPlaceholder {
            return ""
        }
        return trimmed
    }
}
