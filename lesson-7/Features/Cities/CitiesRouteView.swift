//
//  CitiesRouteView.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import Foundation

protocol CitiesRouteView: AnyObject {
    func goBack()
}

extension MainCoordinator: CitiesRouteView {
    func goBack() {
        self.popLast()
    }
}
