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
        let removePhotoTapped: Observable<Void>
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
        let showEmptyAlert = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        let success = PublishRelay<Void>()
        let failure = PublishRelay<Void>()
        let removeFlag = BehaviorRelay<Bool>(value: false)
        
        input.removePhotoTapped
            .map { true }
            .bind(to: removeFlag)
            .disposed(by: disposeBag)

        input.photo
            .map { _ in false }
            .bind(to: removeFlag)
            .disposed(by: disposeBag)
        
        input.editButtonTapped
            .withLatestFrom(Observable.combineLatest(
                input.title.startWith(diary.title),
                input.content.startWith(diary.content),
                input.photo.startWith(nil),
                input.favoriteTeam.startWith(diary.favoriteTeam),
                input.seat.startWith(diary.seat),
                removeFlag.asObservable().startWith(false)
            ))
            .flatMapLatest { [weak self] (title, content, photo, favoriteTeam, seat, shouldRemove) -> Observable<Void> in
                guard let self = self else { return .empty() }
                
                let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                let cleanedContent = self.cleanContent(content)
                if trimmedTitle.isEmpty {
                    showEmptyAlert.accept(())
                    return .empty()
                }
                let hadImageBefore = (self.diary.imageURL != nil)
                let userSelectedNewImage = (photo != nil)
                let isImageRemoved = (shouldRemove && hadImageBefore)
                let photoDataToSend: Data? = userSelectedNewImage ? photo : nil
                isLoading.accept(true)
                return useCase.updateDiary(
                    diaryId: diary.id,
                    title: trimmedTitle,
                    favoriteTeam: favoriteTeam,
                    seat: seat,
                    content: cleanedContent,
                    photoData: photoDataToSend,
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
            initialTitle: Driver.just(diary.title),
            initialContent: Driver.just(diary.content),
            initialImageURL: Driver.just(diary.imageURL),
            initialTeams: Driver.just([diary.homeTeam, diary.awayTeam]),
            initialFavoriteTeam: Driver.just(diary.favoriteTeam),
            initialSeat: Driver.just(diary.seat),
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
