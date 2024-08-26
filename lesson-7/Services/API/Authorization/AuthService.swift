//
//  AuthService.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 25.08.2024.
//

import Foundation
import Combine
import CombineExt

enum AuthState {
    case success, failed(message: String?)
}

final class AuthService: Authenticatable {
    private let apiService: AuthAPIServiceContainable
    
    let authCompleted = PassthroughSubject<AuthState, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(apiService: AuthAPIServiceContainable) {
        self.apiService = apiService
    }
    
    func login() {
        let request = Just(())
            .filter { KeychainManager.shared.token.isNil }
            .map { [unowned self] in
                self.apiService.postToken()
                    .materialize()
            }
            .switchToLatest()
            .share()
        
        request
            .values()
            .sink { [weak self] value in
                KeychainManager.shared.token = value.accessToken
                self?.authCompleted.send(.success)
            }
            .store(in: &cancellables)
        
        request
            .failures()
            .print("ERROR!")
            .sink { [weak self] error in
                self?.authCompleted.send(.failed(message: error.localizedDescription))
            }
            .store(in: &cancellables)
        
        Just(())
            .filter{ KeychainManager.shared.token.isNotNil }
            .sink { [weak self] in
                self?.authCompleted.send(.success)
            }
            .store(in: &cancellables)
    }
}

protocol Authenticatable {
    var authCompleted: PassthroughSubject<AuthState, Never> { get }
    
    func login()
}
