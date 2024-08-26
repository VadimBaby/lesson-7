//
//  Optional.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation

extension Optional where Wrapped == String {
    var orEmpty: String {
        self ?? ""
    }
    
    var isNotNilOrEmpty: Bool {
        guard let self else { return false }
        return !self.isEmpty
    }
    
    var isNil: Bool {
        self == nil
    }
    
    var isNotNil: Bool {
        self != nil
    }
}
 
extension Optional where Wrapped: BinaryFloatingPoint {
    var orZero: Wrapped {
        self ?? .zero
    }
}

extension Optional where Wrapped: BinaryInteger {
    var orZero: Wrapped {
        self ?? .zero
    }
}
