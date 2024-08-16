//
//  SettingsRouterVie.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 16.08.2024.
//

import Foundation

protocol SettingsRouterView: AnyObject {
    func goBack()
}

extension MainCoordinator: SettingsRouterView { }
