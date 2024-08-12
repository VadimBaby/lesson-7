//
//  Combiner.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation
import Combine

protocol Combiner: AnyObject {
    associatedtype S
    associatedtype T
    
    var input: T { get }
    var output: S { get set }
    
    var cancellables: Set<AnyCancellable> { get set }
    
    func printErrors<T: Error>(_ publisher: AnyPublisher<T, Never>)
    func cancelAllCancellables()
}

extension Combiner {
    func printErrors<T: Error>(_ publisher: AnyPublisher<T, Never>) {
        publisher
            .sink { print($0) }
            .store(in: &cancellables)
    }
    
    func cancelAllCancellables() {
        cancellables.forEach{ $0.cancel() }
        cancellables.removeAll()
    }
}
