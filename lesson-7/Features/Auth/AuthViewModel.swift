//
//  AuthViewModel.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import Foundation
import Combine
import CombineExt

final class AuthViewModel: ObservableObject {
    let input: Input
    @Published var output: Output
    
    private let authService: Authenticatable
    
    private let appState: PassthroughSubject<AppState, Never>
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init(
        authService: Authenticatable,
        appState: PassthroughSubject<AppState, Never>
    ) {
        self.input = Input()
        self.output = Output()
        self.authService = authService
        self.appState = appState
        
        self.bind()
    }
}

private extension AuthViewModel {
    func bind() {
        input.onPress
            .ensure { [unowned self] in
                self.output.contentState = .loading
                self.replaceWithMockData()
            }
            .sink { [weak self] in
                self?.authService.login()
            }
            .store(in: &cancellables)
        
        authService.authCompleted
            .sink { [weak self] state in
                switch state {
                case .success:
                    self?.appState.send(.successAuth)
                case .failed(let message):
                    self?.output.contentState = .error(message: message)
                }
            }
            .store(in: &cancellables)
    }
    
    func replaceWithMockData() {
        #if DEBUG
        output.login = APISecureKeys.login
        output.password = APISecureKeys.password
        #endif
    }
}

extension AuthViewModel {
    struct Input {
        let onPress = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        var contentState: LoadableViewState = .loaded
        var login: String = ""
        var password: String = ""
        var disabled: Bool {
            login.isEmpty || password.isEmpty
        }
    }
}
