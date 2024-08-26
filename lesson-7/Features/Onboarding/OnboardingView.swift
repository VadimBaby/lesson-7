//
//  OnboardingView.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 24.08.2024.
//

import SwiftUI

struct OnboardingView: View {
    @Environment(\.bounds) private var bounds: CGRect
    
    @StateObject private var viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    @Namespace private var namespace
    
    var body: some View {
        VStack {
            onboardingItem(viewModel.output.currentStep)
                .frame(height: bounds.height * 0.5)
            
            Spacer()
            
            HStack {
                ForEach(viewModel.output.steps) { step in
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 10, height: 10)
                        .overlay {
                            if viewModel.output.currentStep == step {
                                Circle()
                                    .fill(Color.ligthGreen)
                                    .matchedGeometryEffect(id: "circle", in: namespace)
                            }
                        }
                }
            }
            
            Spacer()
            
            Button(viewModel.output.currentStep.buttonTitle, send: viewModel.input.pressButton)
                .primaryButton(color: .ligthGreen)
        }
        .padding()
        .animation(.easeInOut, value: viewModel.output.currentStep)
    }
}

private extension OnboardingView {
    @ViewBuilder func onboardingItem(_ step: OnboardingStep) -> some View {
        VStack {
            Image(step.nameImage)
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 20)
            
            Spacer()
            
            VStack(spacing: 20) {
                Text(step.title)
                    .font(25, weight: .bold, color: .primary)
                Text(step.subtitle)
                    .font(20, weight: .medium, color: .gray)
            }
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    OnboardingView(viewModel: .init(appState: .init()))
}
