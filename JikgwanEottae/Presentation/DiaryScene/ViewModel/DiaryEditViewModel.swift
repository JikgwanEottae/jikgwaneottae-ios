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
    private let usecase: DiaryUseCaseProtocol
    private let selectedDiary: Diary
    private let disposeBag = DisposeBag()
    
    struct Input {
        let selectedPhotoData: PublishRelay<Data?>
        let supportTeam: Observable<String>
        let seat: Observable<String>
        let memo: Observable<String>
        let isPhotoChanged: BehaviorRelay<Bool>
        let updateButtonTapped: Observable<Void>
        let deleteButtonTapped: Observable<Void>
    }
    
    struct Output {
        let initialPhoto: Driver<String?>
        let initialSupportTeam: Driver<String>
        let initialSeat: Driver<String>
        let initialMemo: Driver<String>
        let supportTeamPickerItems: Driver<[String]>
        let isLoading: Driver<Bool>
        let updateSuccess: Signal<Void>
        let updateFailure: Signal<Void>
        let deleteSuccess: Signal<Void>
        let deleteFailure: Signal<Void>
        let formInputError: Signal<Void>
    }
    
    public init(usecase: DiaryUseCaseProtocol, selectedDiary: Diary) {
        self.usecase = usecase
        self.selectedDiary = selectedDiary
    }
    
    public func transform(input: Input) -> Output {
        let formInputErrorRelay = PublishRelay<Void>()
        let isLoadingDriver = BehaviorRelay<Bool>(value: false)
        let updateSuccessRelay = PublishRelay<Void>()
        let updateFailureRelay = PublishRelay<Void>()
        let deleteSuccessRelay = PublishRelay<Void>()
        let deleteFailureRelay = PublishRelay<Void>()
        
        let inputCombined = Observable.combineLatest(
            input.selectedPhotoData
                .startWith(nil),
            input.supportTeam
                .skip(1)
                .startWith(selectedDiary.favoriteTeam),
            input.seat
                .skip(1)
                .startWith(selectedDiary.seat),
            input.memo
                .skip(1)
                .startWith(selectedDiary.memo),
            input.isPhotoChanged
        )
        
        input.updateButtonTapped
            .withLatestFrom(inputCombined)
            .filter { selectedPhotoData, supportTeam, seat, memo, isPhotoChanged in
                if supportTeam.isEmpty {
                    formInputErrorRelay.accept(())
                    return false
                }
                return true
            }
            .withUnretained(self)
            .flatMap { owner, values -> Observable<Void> in
                let (photoData, supportTeam, seat, memo, isPhotoChanged) = values
                let isImageRemoved = (photoData == nil && isPhotoChanged)
                isLoadingDriver.accept(true)
                return owner.usecase.updateDiary(
                    diaryId: owner.selectedDiary.id,
                    favoriteTeam: supportTeam,
                    seat: seat,
                    memo: memo,
                    imageData: photoData,
                    isImageRemoved: isImageRemoved
                )
                .andThen(Observable.just(()))
                .catch { error in
                    isLoadingDriver.accept(false)
                    updateFailureRelay.accept(())
                    return Observable.empty()
                }
            }
            .subscribe(onNext: {
                isLoadingDriver.accept(false)
                updateSuccessRelay.accept(())
            })
            .disposed(by: disposeBag)
        
        input.deleteButtonTapped
            .withUnretained(self)
            .flatMap { owner, _ -> Observable<Void> in
                isLoadingDriver.accept(true)
                return owner.usecase.deleteDiary(diaryID: owner.selectedDiary.id, gameDate: owner.selectedDiary.gameDate)
                    .andThen(Observable.just(()))
                    .catch { error in
                        deleteFailureRelay.accept(())
                        isLoadingDriver.accept(false)
                        return Observable.empty()
                    }
            }
            .subscribe(onNext: {
                deleteSuccessRelay.accept(())
                isLoadingDriver.accept(false)
            })
            .disposed(by: disposeBag)
        
        return Output(
            initialPhoto: Driver.just(selectedDiary.imageURL),
            initialSupportTeam: Driver.just(selectedDiary.favoriteTeam),
            initialSeat: Driver.just(selectedDiary.seat),
            initialMemo: Driver.just(selectedDiary.memo),
            supportTeamPickerItems: Driver.just([selectedDiary.homeTeam, selectedDiary.awayTeam]),
            isLoading: isLoadingDriver.asDriver(),
            updateSuccess: updateSuccessRelay.asSignal(),
            updateFailure: updateFailureRelay.asSignal(),
            deleteSuccess: deleteSuccessRelay.asSignal(),
            deleteFailure: deleteFailureRelay.asSignal(),
            formInputError: formInputErrorRelay.asSignal()
        )
    }
}
