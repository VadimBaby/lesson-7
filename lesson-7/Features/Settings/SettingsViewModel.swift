//
//  SettingsViewModel.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 15.08.2024.
//

import Foundation
import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    let input: Input
    
    private var cancellables: Set<AnyCancellable> = .init()
    
    private weak var router: SettingsRouterView? = nil
    
    init(router: SettingsRouterView?) {
        self.router = router
        
        self.input = Input()
        
        self.bind()
    }
}

private extension SettingsViewModel {
    func bind() {
        input.goBack
            .sink { [weak self] in
                self?.router?.goBack()
            }
            .store(in: &cancellables)
    }
}

extension SettingsViewModel {
    struct Input {
        let goBack = PassthroughSubject<Void, Never>()
    }
}
