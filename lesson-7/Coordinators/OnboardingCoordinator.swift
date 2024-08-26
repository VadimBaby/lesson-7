//
//  OnboardingCoordinator.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import Foundation
import Stinsen
import SwiftUI
import Combine

final class OnboardingCoordinator: NavigationCoordinatable {
    var stack: Stinsen.NavigationStack<OnboardingCoordinator> = .init(initial: \.start)
    
    @Root var start = makeStart
    
    private let appState: PassthroughSubject<AppState, Never>
    
    init(appState: PassthroughSubject<AppState, Never>) {
        self.appState = appState
    }
}

private extension OnboardingCoordinator {
    @ViewBuilder func makeStart() -> some View {
        let viewModel = OnboardingViewModel(appState: appState)
        OnboardingView(viewModel: viewModel)
    }
}

