//
//  MainViewRouter.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import Foundation

protocol MainViewRouter: AnyObject {
    func routeToCities()
    func routeToSettings(onDismiss: @escaping VoidAction)
}

extension MainCoordinator: MainViewRouter {
    func routeToCities() {
        self.route(to: \.cities)
    }
    
    func routeToSettings(onDismiss: @escaping VoidAction) {
        self.route(to: \.settings, onDismiss: onDismiss)
    }
}
