//
//  ErrorView.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import SwiftUI

struct ErrorView: View {
    
    private let message: String
    private let onReload: VoidAction
    
    init(message: String? = nil, onReload: @escaping VoidAction = {}) {
        self.message = message ?? "You get an error."
        self.onReload = onReload
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Ooops...")
                .font(.system(size: 70, weight: .bold))
            
            Text(message)
                .font(.system(size: 25, weight: .light))
            
            Text("Please try again.")
                .font(.system(size: 20, weight: .bold))
            
            Button(action: onReload) {
                Text("Try Again")
                    .foregroundStyle(Color.black)
                    .padding()
                    .background(Color.white)
                    .clipShape(.rect(cornerRadius: 15))
            }
        }
        .foregroundStyle(Color.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.error.ignoresSafeArea())
    }
}

#Preview {
    ErrorView()
}
