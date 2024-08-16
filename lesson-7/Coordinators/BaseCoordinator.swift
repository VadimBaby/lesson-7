//
//  BaseCoordinator.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import Foundation
import Stinsen
import SwiftUI

final class BaseCoordinator: NavigationCoordinatable {
    var stack = Stinsen.NavigationStack<BaseCoordinator>(initial: \.start)
    
    @Root var start = makeMain
    
    @Injected private var settingsService: SettingsService
    
    func customize(_ view: AnyView) -> some View {
        view
            .environmentObject(settingsService)
    }
    
    private func makeMain() -> NavigationViewCoordinator<MainCoordinator> {
        NavigationViewCoordinator(MainCoordinator(settingsService: settingsService))
    }
}
