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
    
    private let state: LoadableViewState
    private let content: () -> Content
    private let onAppear: VoidAction
    private let onReload: VoidAction
    
    init(
        state: LoadableViewState,
        content: @escaping () -> Content,
        onAppear: @escaping VoidAction = {},
        onReload: @escaping VoidAction = {}
    ) {
        self.state = state
        self.content = content
        self.onAppear = onAppear
        self.onReload = onReload
    }
    
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
