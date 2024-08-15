//
//  DependencyContainer.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import Foundation

struct Dependency {
    
    typealias ResolveBlock<T> = () -> T

    private(set) var value: Any!
    private let resolveBlock: ResolveBlock<Any>
    let name: String

    init<T>(_ block: @escaping ResolveBlock<T>) {
        resolveBlock = block
        name = String(describing: T.self)
    }
    mutating func resolve() {
        value = resolveBlock()
    }
}

class Dependencies {
    @resultBuilder struct DependencyBuilder {
        static func buildBlock(_ dependency: Dependency) -> Dependency { dependency }
        static func buildBlock(_ dependencies: Dependency...) -> [Dependency] { dependencies }
    }

    convenience init(@DependencyBuilder _ dependencies: () -> [Dependency]) {
        self.init()
        dependencies().forEach { register($0) }
    }

    convenience init(@DependencyBuilder _ dependency: () -> Dependency) {
        self.init()
        register(dependency())
    }

    static private(set) var shared = Dependencies()

    fileprivate var dependencies = [Dependency]()

    func register(_ dependency: Dependency) {
        guard dependencies.firstIndex(where: { $0.name == dependency.name }) == nil else {
            debugPrint("\(String(describing: dependency.name)) already registered, ignoring")
            return
        }
        dependencies.append(dependency)
    }

    func build() {
        for index in dependencies.startIndex..<dependencies.endIndex {
            dependencies[index].resolve()
        }
        Self.shared = self
    }

    func resolve<T>() -> T {
        guard let dependency = dependencies.first(where: { $0.value is T })?.value as? T else {
            fatalError("Can't resolve \(T.self)")
        }
        return dependency
    }
}

@propertyWrapper
struct Injected<Dependency> {

    var dependency: Dependency!

    var wrappedValue: Dependency {
        mutating get {
            if dependency == nil {
                let copy: Dependency = Dependencies.shared.resolve()
                self.dependency = copy
            }
            return dependency
        }
        mutating set {
            dependency = newValue
        }
    }
}
