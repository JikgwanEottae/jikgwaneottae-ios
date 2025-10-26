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
    
    private init() {
        let session = Session(interceptor: AuthInterceptor.shared)
        self.provider = MoyaProvider<AuthAPIService>(session: session)
    }
    
    public func authenticateWithKakao(accessToken: String) -> Single<AuthResponseDTO> {
        return provider.rx.request(.authenticateWithKakao(accessToken: accessToken))
            .map(AuthResponseDTO.self)
    }
    
    public func authenticateWithApple(
        identityToken: String,
        authorizationCode: String
    ) -> Single<AuthResponseDTO> {
        return provider.rx.request(.authenticateWithApple(identityToken: identityToken, authorizationCode: authorizationCode))
            .map(AuthResponseDTO.self)
    }
    
    public func setProfileNickname(nickname: String) -> Completable {
        return provider.rx.request(.setProfileNickname(nickname: nickname))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
    
    public func updateProfileImage(
        isImageRemoved: Bool,
        imageData: Data?
    ) -> Single<AuthResponseDTO> {
        return provider.rx.request(.updateProfileImage(isRemoveImage: isImageRemoved, imageData: imageData))
            .map(AuthResponseDTO.self)
    }
    
    public func updateFavoriteTeam(team: String) -> Completable {
        return provider.rx.request(.updateFavoriteTeam(team: team))
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
    
    public func validateRefreshToken(_ refreshToken: String) -> Single<AuthResponseDTO> {
        return provider.rx.request(.validateRefreshToken(refreshToken))
            .map(AuthResponseDTO.self)
    }
    
    public func signOut() -> Completable {
        return provider.rx.request(.signOut)
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
    
    public func withdrawAccount() -> Completable {
        return provider.rx.request(.withdrawAccount)
            .filterSuccessfulStatusCodes()
            .asCompletable()
    }
    
}
