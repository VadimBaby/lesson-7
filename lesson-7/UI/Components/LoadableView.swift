//
//  LoadableView.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import SwiftUI

enum LoadableViewState: Equatable {
    case error(message: String?)
    case loaded
    case loading
}

struct LoadableView<Content: View>: View {
    @Environment(\.bounds) private var bounds: CGRect
    
    let state: LoadableViewState
    let content: () -> Content
    let onAppear: VoidAction
    let onReload: VoidAction
    
    var body: some View {
        Group {
            switch state {
            case .error(let message):
                ErrorView(message: message, onReload: onReload)
                    .transition(.slide)
            case .loaded:
                content()
                    .transition(.move(edge: .top))
            case .loading:
                LoadingView()
                    .transition(
                        .asymmetric(
                            insertion: .opacity,
                            removal: .offset(y: bounds.height / 2)
                        )
                    )
            }
        }
        .onAppear(perform: onAppear)
        .animation(.bouncy, value: state)
    }
}

#Preview {
    LoadableView(
        state: .loading,
        content: { EmptyView() },
        onAppear: {},
        onReload: {}
    )
}
