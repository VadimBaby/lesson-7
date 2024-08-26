//
//  CaseIterable.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import Foundation

extension CaseIterable where Self: Equatable {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        
        return all[next == all.endIndex ? all.startIndex : next]
    }
    
    var isLast: Bool {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        
        return next == all.endIndex
    }
}
