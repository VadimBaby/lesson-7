//
//  OnboardingViewModel.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    let input: Input
    @Published var output: Output
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private let appState: PassthroughSubject<AppState, Never>
    
    init(appState: PassthroughSubject<AppState, Never>) {
        self.input = Input()
        self.output = Output()
        self.appState = appState
        
        self.bind()
    }
}

private extension OnboardingViewModel {
    func bind() {
        input.pressButton
            .sink { [weak self] in
                guard let self = self else { return }
                
                if self.output.currentStep.isLast {
                    UserStorage.shared.isOnboardingDone = true
                    self.appState.send(.onboardingDone)
                } else {
                    let currentStep = self.output.currentStep
                    self.output.currentStep = currentStep.next()
                }
            }
            .store(in: &cancellables)
    }
}

extension OnboardingViewModel {
    struct Input {
        let pressButton = PassthroughSubject<Void, Never>()
    }
    
    struct Output {
        let steps: [OnboardingStep] = OnboardingStep.allCases
        var currentStep: OnboardingStep = .welcome
    }
}
