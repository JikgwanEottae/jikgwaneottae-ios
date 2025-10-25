//
//  AuthInterceptor.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/11/25.
//

import Foundation

import Alamofire
import Moya
import RxSwift

final class AuthInterceptor: RequestInterceptor {
    static let shared = AuthInterceptor()
    private let disposeBag = DisposeBag()
    
    private init() {}
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var request = urlRequest
        if let accessToken = KeychainManager.shared.readAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetry)
            return
        }
        
        guard let refreshToken = KeychainManager.shared.readRefreshToken() else {
            completion(.doNotRetry)
            return
        }
        
        AuthNetworkManager.shared.validateRefreshToken(refreshToken)
            .observe(on: ConcurrentDispatchQueueScheduler(qos: .background))
            .subscribe(onSuccess: { responseDTO in
                guard let accessToken = responseDTO.data?.accessToken else {
                    completion(.doNotRetry)
                    return
                }
                try? KeychainManager.shared.saveAccessToken(accessToken)
                completion(.retry)
            }, onFailure: { _ in
                completion(.doNotRetry)
            })
            .disposed(by: disposeBag)
    }
}
