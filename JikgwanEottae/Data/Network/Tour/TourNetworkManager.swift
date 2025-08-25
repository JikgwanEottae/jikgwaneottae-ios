//
//  TourNetworkManager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 8/24/25.
//

import Foundation

import Moya
import RxSwift

final class TourNetworkManager {
    static let shared = TourNetworkManager()
    private let provider = MoyaProvider<TourAPIService>()
    
    private init() {}
    
    public func fetchTourPlacesByLocation(params: LocationBasedRequestDTO) -> Single<TourPlacePage> {
        return provider.rx.request(.fetchTourPlacesByLocation(params: params))
            .map(LocationBasedResponseDTO.self)
            .map { $0.toDomain() }
    }
}
