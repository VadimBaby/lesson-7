//
//  AuthAPI.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation
import Moya
import Combine
import CombineMoya

final class AuthAPIService {
    private let provider = Provider<AuthEndpoint>()
}

extension AuthAPIService: AuthAPIServiceContainable {
    func postToken() -> AnyPublisher<Token, MoyaError> {
        provider.requestPublisher(.postToken)
            .filterSuccessfulStatusCodes()
            .map(ServerToken.self)
            .map { Token(serverEntity: $0) }
            .mapError({ error in
                print(error.errorUserInfo)
                return error
            })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

protocol AuthAPIServiceContainable {
    func postToken() -> AnyPublisher<Token, MoyaError>
}
