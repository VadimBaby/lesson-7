//
//  DIContainer.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 18.08.2024.
//

import Foundation
import Swinject

final class DependencyContainer {
    private let container: Swinject.Container = .init()
    
    static private(set) var shared = DependencyContainer()
    
    func register<Service>(
        _ serviceType: Service.Type,
        name: String? = nil,
        factory: @escaping (Resolver) -> Service
    ) {
        container.register(serviceType, name: name, factory: factory)
    }
    
    func register<Service>(_ serviceType: Service.Type, service: Service) {
        container.register(serviceType) { _ in
            service
        }
    }
    
    func resolve<Service>(_ serviceType: Service.Type, name: String? = nil) -> Service? {
        container.resolve(serviceType, name: name)
    }
    
    func resolve<T>() -> T {
        guard let dependency = container.resolve(T.self) else { fatalError("Can't resolve \(T.self)") }
        
        return dependency
    }
    
    func build() {
        Self.shared = self
    }
}

@propertyWrapper
struct Injected<Dependency> {

    var dependency: Dependency!

    var wrappedValue: Dependency {
        mutating get {
            if dependency == nil {
                let copy: Dependency = DependencyContainer.shared.resolve()
                self.dependency = copy
            }
            return dependency
        }
        mutating set {
            dependency = newValue
        }
    }
}

