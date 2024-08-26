//
//  AuthCoordinator.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import Foundation
import Stinsen
import SwiftUI
import Combine

final class AuthCoordinator: NavigationCoordinatable {
    var stack: Stinsen.NavigationStack<AuthCoordinator> = .init(initial: \.start)
    
    @Root var start = makeStart
    
    @Injected private var authService: AuthService
    
    private let appState: PassthroughSubject<AppState, Never>
    
    init(appState: PassthroughSubject<AppState, Never>) {
        self.appState = appState
    }
}

private extension AuthCoordinator {
    @ViewBuilder func makeStart() -> some View {
        let viewModel = AuthViewModel(authService: authService, appState: appState)
        AuthView(viewModel: viewModel)
    }
}
