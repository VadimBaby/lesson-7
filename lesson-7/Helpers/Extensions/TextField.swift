//
//  TextField.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import Foundation
import SwiftUI

extension TextField {
    func primaryTextField() -> some View {
        self
            .textFieldStyle(PrimaryTextFieldStyle())
    }
}

extension SecureField {
    func primaryTextField() -> some View {
        self
            .textFieldStyle(PrimaryTextFieldStyle())
    }
}
