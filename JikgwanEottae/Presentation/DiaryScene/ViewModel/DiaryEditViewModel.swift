//
//  DiaryEditViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/8/25.
//

// MARK: - 직관 일기 생성 및 편집을 담당하는 뷰 모델입니다.

import Foundation

import RxSwift
import RxCocoa

final class DiaryEditViewModel: ViewModelType {
    private let useCase: DiaryUseCaseProtocol
    private let diary: Diary
    private let disposeBag = DisposeBag()
    
    struct Input {
        let title: Observable<String>
        let content: Observable<String>
        let photo: Observable<Data?>
        let favoriteTeam: Observable<String>
        let seat: Observable<String>
        let editButtonTapped: Observable<Void>
    }
    
    struct Output {
        let initialTitle: Driver<String>
        let initialContent: Driver<String>
        let initialImageURL: Driver<String?>
        let initialTeams: Driver<[String]>
        let initialFavoriteTeam: Driver<String>
        let initialSeat: Driver<String>
        let showEmptyAlert: Signal<Void>
        let isLoading: Driver<Bool>
        let editSuccess: Signal<Void>
        let editFailure: Signal<Void>
    }
    
    init(useCase: DiaryUseCaseProtocol, diary: Diary) {
        self.useCase = useCase
        self.diary = diary
    }
}

extension DiaryEditViewModel {
    public func transform(input: Input) -> Output {
        let titleRelay = BehaviorRelay(value: diary.title)
        let contentRelay = BehaviorRelay(value: diary.content)
        let imageUrlRelay = BehaviorRelay(value: diary.imageURL)
        let teamsRelay = BehaviorRelay(value: [diary.homeTeam, diary.awayTeam])
        let favoriteTeamRelay = BehaviorRelay(value: diary.favoriteTeam)
        let seatRelay = BehaviorRelay(value: diary.seat)
        let showEmptyAlert = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let success = PublishRelay<Void>()
        let failure = PublishRelay<Void>()
        
        input.title
            .bind(to: titleRelay)
            .disposed(by: disposeBag)
        
        input.content
            .bind(to: contentRelay)
            .disposed(by: disposeBag)
        
        input.favoriteTeam
            .bind(to: favoriteTeamRelay)
            .disposed(by: disposeBag)
        
        input.seat
            .bind(to: seatRelay)
            .disposed(by: disposeBag)
        
        input.editButtonTapped
            .withLatestFrom(Observable.combineLatest(
                titleRelay.asObservable(),
                contentRelay.asObservable(),
                input.photo.startWith(nil),
                favoriteTeamRelay.asObservable(),
                seatRelay.asObservable()
            ))
            .flatMapLatest { [weak self] (title, content, photo, favoriteTeam, seat) -> Observable<Void> in
                guard let self = self else { return .empty() }
                let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                let cleanedContent = self.cleanContent(content)
                if trimmedTitle.isEmpty {
                    showEmptyAlert.accept(())
                    return .empty()
                }
                let isImageRemoved = (photo == nil ? true : false )
                isLoading.accept(true)
                return useCase.updateDiary(
                    diaryId: diary.id,
                    title: trimmedTitle,
                    favoriteTeam: favoriteTeam,
                    seat: seat,
                    content: cleanedContent,
                    photoData: photo,
                    isImageRemoved: isImageRemoved
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
            initialTitle: titleRelay.asDriver(),
            initialContent: contentRelay.asDriver(),
            initialImageURL: imageUrlRelay.asDriver(),
            initialTeams: teamsRelay.asDriver(),
            initialFavoriteTeam: favoriteTeamRelay.asDriver(),
            initialSeat: seatRelay.asDriver(),
            showEmptyAlert: showEmptyAlert.asSignal(),
            isLoading: isLoading.asDriver(),
            editSuccess: success.asSignal(),
            editFailure: failure.asSignal()
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
