//
//  DiaryDetailViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/23/25.
//

import Foundation

import RxSwift
import RxCocoa

final class DiaryDetailViewModel: ViewModelType {
    private let useCase: DiaryUseCaseProtocol
    private let diary: Diary
    private let disposeBag = DisposeBag()
    
    struct Input {
        let editButtonTapped: Observable<Void>
        let deleteButtonTapped: Observable<Void>
    }
    
    struct Output {
        let imageURL: Driver<String?>
        let title: Driver<String>
        let gameInfo: Driver<String>
        let metaInfo: Driver<String>
        let content: Driver<String>
        let date: Driver<String>
        let result: Driver<String>
        let isLoading: Driver<Bool>
        let deleteSuccess: Signal<Void>
        let deleteFailure: Signal<Void>
        let editDiary: Signal<Diary>
    }
    
    init(useCase: DiaryUseCaseProtocol, diary: Diary) {
        self.useCase = useCase
        self.diary = diary
    }
}

extension DiaryDetailViewModel {
    public func transform(input: Input) -> Output {
        let result = Driver.just(makeResultDescription(for: diary))
        let imageURL = Driver.just(diary.imageURL)
        let title = Driver.just(diary.title)
        let content = Driver.just(makeContentDescription(for: diary))
        let gameInfo = Driver.just("\(diary.homeTeam) \(diary.homeScore) : \(diary.awayScore) \(diary.awayTeam)")
        let metaInfo = Driver.just(makeMetaInfoDescription(for: diary))
        let date = Driver.just(makeFormatDateString(diary.gameDate))
        let isLoading = BehaviorRelay<Bool>(value: false)
        let deleteSuccess = PublishRelay<Void>()
        let deleteFailure = PublishRelay<Void>()
        
        let editDiary = input.editButtonTapped
            .compactMap{ [weak self] in self?.diary }
            .asSignal(onErrorSignalWith: .empty())
        
        input.deleteButtonTapped
            .flatMapLatest { [weak self] _ -> Observable<Void> in
                guard let self = self else { return .empty() }
                isLoading.accept(true)
                return useCase.deleteDiary(diaryId: diary.id)
                    .andThen(Observable.just(()))
            }
            .subscribe(onNext: {
                isLoading.accept(false)
                deleteSuccess.accept(())
            }, onError: { error in
                isLoading.accept(false)
                deleteFailure.accept(())
            })
            .disposed(by: disposeBag)
        
        return Output(
            imageURL: imageURL,
            title: title,
            gameInfo: gameInfo,
            metaInfo: metaInfo,
            content: content,
            date: date,
            result: result,
            isLoading: isLoading.asDriver(),
            deleteSuccess: deleteSuccess.asSignal(),
            deleteFailure: deleteFailure.asSignal(),
            editDiary: editDiary
        )
    }
}

extension DiaryDetailViewModel {
    private func makeResultDescription(for diary: Diary) -> String {
        switch diary.result {
        case "WIN":
            return "승리"
        case "LOSS":
            return "패배"
        case "DRAW":
            return "무승부"
        default:
            return ""
        }
    }
    
    private func makeMetaInfoDescription(for diary: Diary) -> String {
        let ballpark = diary.ballpark
        let seat = diary.seat.trimmingCharacters(in: .whitespacesAndNewlines)
        return seat.isEmpty ? ballpark : "\(ballpark) | \(seat)"
    }
    
    private func makeContentDescription(for diary: Diary) -> String {
        let trimmed = diary.content.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "작성한 내용이 없어요" : trimmed
    }
    
    private func makeFormatDateString(_ dateString: String) -> String {
        let formatter = DateFormatter.getDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return dateString
        }
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter.string(from: date)
    }
}
