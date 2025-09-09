//
//  AuthNetworkManager.swift
//  JikgwanEottae
//
//  Created by 7aeHoon on 9/5/25.
//

import Foundation

import Moya
import RxSwift

final class AuthNetworkManager {
    static let shared = AuthNetworkManager()
    private let provider: MoyaProvider<AuthAPIService>
    
    private let tokenClosure: (TargetType) -> String = { _ in
        return KeychainManager.shared.readAccessToken() ?? ""
    }
    
    private init() {
        let authPlugin = AccessTokenPlugin(tokenClosure: tokenClosure)
        self.provider = MoyaProvider(plugins: [authPlugin])
    }
    
    public func authenticateWithKakao(accessToken: String) -> Single<AuthResponseDTO> {
        return provider.rx.request(.authenticateWithKakao(accessToken: accessToken))
            .map(AuthResponseDTO.self)
    }
    
    public func authenticateWithApple(
        identityToken: String,
        authorizationCode: String
    ) -> Single<SignInResponseDTO> {
        return provider.rx.request(.authenticateWithApple(identityToken: identityToken, authorizationCode: authorizationCode))
            .map(SignInResponseDTO.self)
    }
    
    public func setProfileNickname(nickname: String) -> Completable {
        return provider.rx.request(.setProfileNickname(nickname: nickname))
            .filterSuccessfulStatusCodes()
            .do(onSuccess: { response in
                print("응답 상태: \(response.statusCode)")
            })
            .asCompletable()
    }
    
    public func validateRefreshToken(_ refreshToken: String) -> Single<TokenRefreshResponseDTO> {
        return provider.rx.request(.validateRefreshToken(refreshToken))
            .map(TokenRefreshResponseDTO.self)
    }
    
    public func signOut() -> Completable {
        return provider.rx.request(.signOut)
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
}
