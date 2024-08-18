//
//  AppDelegate.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import SwiftUI

final class AppDelegate: NSObject, UIApplicationDelegate {
    
    private let locationService = LocationService()
    private let authService = AuthAPIService()
    private let apiService = WeatherAPIService()
    private var settings = SettingsService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        registerDependencies()
        
        return true
    }
    
    private func registerDependencies() {
        let container = DependencyContainer()
        
        container.register(LocationService.self, service: locationService)
        container.register(AuthAPIService.self, service: authService)
        container.register(WeatherAPIService.self, service: apiService)
        container.register(SettingsService.self, service: settings)
        
        container.build()
    }
}
