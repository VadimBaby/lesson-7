//
//  Publisher.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 25.08.2024.
//

import Foundation
import Combine

extension Publisher {
    func ensure(_ callback: @escaping (Self.Output) -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: callback)
    }
    
    func ensure(_ callback: @escaping () -> Void) -> Publishers.HandleEvents<Self> {
        handleEvents(receiveOutput: { _ in callback() })
    }
}

extension Publisher where Failure == Never {
    func sink(send: PassthroughSubject<Void, Never>) -> AnyCancellable {
        self
            .mapToVoid()
            .sink {
                send.send()
            }
    }
}
