//
//  UpdateCoordinator.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import Foundation
import Stinsen
import SwiftUI

final class UpdateCoordinator: NavigationCoordinatable {
    var stack: Stinsen.NavigationStack<UpdateCoordinator> = .init(initial: \.start)
    
    @Root var start = makeStart
}

private extension UpdateCoordinator {
    @ViewBuilder func makeStart() -> some View {
        UpdateView()
    }
}
