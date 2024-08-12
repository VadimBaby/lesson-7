//
//  ProgressView.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation
import SwiftUI

extension ProgressView {
    func circlesProgressView() -> some View {
        self
            .progressViewStyle(CirclesProgressViewStyle())
    }
}
