//
//  BaseCoordinator.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import Foundation
import Stinsen
import SwiftUI
import Combine

enum AppState {
    case onboardingDone, successAuth
}

final class BaseCoordinator: NavigationCoordinatable {
    var stack: Stinsen.NavigationStack<BaseCoordinator>
    
    @Root var start = makeMain
    @Root var update = makeUpdate
    @Root var onboarding = makeOnboarding
    @Root var auth = makeAuth
    
    private let appState = PassthroughSubject<AppState, Never>()
    
    @Injected private var settingsService: SettingsService
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    init() {
        if Bool.random() {
            stack = .init(initial: \.update)
        } else if !UserStorage.shared.isOnboardingDone {
            stack = .init(initial: \.onboarding)
        } else if KeychainManager.shared.token.isNil {
            stack = .init(initial: \.auth)
        } else {
            stack = .init(initial: \.start)
        }
        
        self.bind()
    }
    
    func customize(_ view: AnyView) -> some View {
        view
            .environmentObject(settingsService)
    }
}

private extension BaseCoordinator {
    func bind() {
        appState
            .sink { [weak self] state in
                self?.changeRoot(with: state)
            }
            .store(in: &cancellables)
    }
}

private extension BaseCoordinator {
    func makeMain() -> NavigationViewCoordinator<MainCoordinator> {
        NavigationViewCoordinator(MainCoordinator(settingsService: settingsService))
    }
    
    func makeUpdate() -> NavigationViewCoordinator<UpdateCoordinator> {
        NavigationViewCoordinator(UpdateCoordinator())
    }
    
    func makeOnboarding() -> NavigationViewCoordinator<OnboardingCoordinator> {
        NavigationViewCoordinator(OnboardingCoordinator(appState: appState))
    }
    
    func makeAuth() -> NavigationViewCoordinator<AuthCoordinator> {
        NavigationViewCoordinator(AuthCoordinator(appState: appState))
    }
    
    func changeRoot(with state: AppState) {
        switch state {
        case .onboardingDone:
            self.root(\.auth)
        case .successAuth:
            self.root(\.start)
        }
    }
}
