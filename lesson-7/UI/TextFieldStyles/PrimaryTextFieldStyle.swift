//
//  PrimaryTextFieldStyle.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import Foundation
import SwiftUI

struct PrimaryTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(Color.gray.opacity(0.2))
            .textInputAutocapitalization(.never)
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        
        TextField("asdasdasd", text: .constant(""))
            .textFieldStyle(PrimaryTextFieldStyle())
            .padding()
    }
}
