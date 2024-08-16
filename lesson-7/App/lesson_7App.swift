//
//  lesson_7App.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import SwiftUI

@main
struct lesson_7App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    var body: some Scene {
        WindowGroup {
            BaseCoordinator().view()
        }
    }
}
