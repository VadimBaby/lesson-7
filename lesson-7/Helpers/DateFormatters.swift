//
//  DateFormatters.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 12.08.2024.
//

import Foundation

struct DateFormatters {
    static let shared = DateFormatters()
    
    var mediumDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }
}
