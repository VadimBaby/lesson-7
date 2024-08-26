//
//  AuthView.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject private var viewModel: AuthViewModel
    
    init(viewModel: AuthViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        LoadableView(
            state: viewModel.output.contentState,
            content: content,
            onReload: viewModel.input.onPress.send
        )
    }
}

private extension AuthView {
    @ViewBuilder func content() -> some View {
        VStack(spacing: 15) {
            TextField("Login", text: $viewModel.output.login)
                .primaryTextField()
            
            SecureField("Password", text: $viewModel.output.password)
                .primaryTextField()
            
            Button("Войти", send: viewModel.input.onPress)
                .primaryButton(color: .blue, disabled: viewModel.output.disabled)
        }
        .padding()
    }
}

#Preview {
    AuthView(viewModel: .init(authService: AuthService(apiService: AuthAPIService()), appState: .init()))
}
