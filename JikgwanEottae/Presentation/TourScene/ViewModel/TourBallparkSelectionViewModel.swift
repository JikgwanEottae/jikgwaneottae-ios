//
//  TourBallparkSelectionViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import Foundation

import RxSwift
import RxCocoa

final class TourBallparkSelectionViewModel: ViewModelType {
    private let useCase: TourUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    struct Input {
        let team: PublishRelay<KBOTeam>
    }
    
    struct Output {
        let fetchSuccess: Observable<NearbyTourPlace>
        let fetchFailure: Signal<Void>
        let isLoading: Driver<Bool>
    }
    
    init(useCase: TourUseCaseProtocol) {
        self.useCase = useCase
    }
}

extension TourBallparkSelectionViewModel {
    public func transform(input: Input) -> Output {
        let success = PublishRelay<NearbyTourPlace>()
        let failure = PublishRelay<Void>()
        let isLoading = BehaviorRelay<Bool>(value: false)
        
        input.team
            .flatMapLatest { [weak self] team -> Observable<NearbyTourPlace> in
                guard let self = self else { return .empty() }
                let teamStr = "\(team)"
                isLoading.accept(true)
                return useCase.fetchNearbyTourPlace(team: teamStr)
                    .asObservable()
            }
            .subscribe(onNext: { nearbyTourPlace in
                isLoading.accept(false)
                success.accept(nearbyTourPlace)
            }, onError: { error in
                isLoading.accept(false)
                failure.accept(())
            })
            .disposed(by: disposeBag)

        
        return Output(
            fetchSuccess: success.asObservable(),
            fetchFailure: failure.asSignal(),
            isLoading: isLoading.asDriver()
        )
    }
}
