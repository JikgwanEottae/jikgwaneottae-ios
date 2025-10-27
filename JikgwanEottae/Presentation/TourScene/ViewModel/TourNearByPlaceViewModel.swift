//
//  TourNearByPlaceViewModel.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 10/26/25.
//

import Foundation

import RxSwift
import RxCocoa

final class TourNearByPlaceViewModel: ViewModelType {
    private let places: NearbyTourPlace
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        let stadium: Driver<String>
        let attractions: Driver<[Attraction]>
    }
    
    init(places: NearbyTourPlace) {
        self.places = places
    }
    
}

extension TourNearByPlaceViewModel {
    public func transform(input: Input) -> Output {
        let stadium = Driver.just(places.stadium)
        let attractions = Driver.just(places.attractions)
        
        
        return Output(
            stadium: stadium,
            attractions: attractions
        )
    }
}
