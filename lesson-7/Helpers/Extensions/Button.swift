//
//  Button.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 14.08.2024.
//

import SwiftUI
import Combine

// MARK: - Custom Inits

extension Button {
    init(send: PassthroughSubject<Void, Never>, label: () -> Label) {
        self.init(action: send.send, label: label)
    }
    
    init(_ titleKey: String, send: PassthroughSubject<Void, Never>) where Label == Text {
        self.init(titleKey, action: { send.send() })
    }
    
    init<T>(send: PassthroughSubject<T, Never>, model: T, label: () -> Label) {
        self.init(
            action: { send.send(model) },
            label: label)
    }
    
    init(dismiss: DismissAction, label: () -> Label) {
        self.init(
            action: { dismiss() },
            label: label
        )
    }
    
    init(dismiss: DismissAction, with sound: Sound, isSoundOn: Bool = true, label: () -> Label) {
        self.init(
            action: {
                if isSoundOn {
                    AudioPlayer.shared.playSound(sound: .what)
                }
                
                dismiss()
            },
            label: label
        )
    }
    
    init(action: @escaping VoidAction, with sound: Sound, isSoundOn: Bool = true, label: () -> Label) {
        self.init(action: {
            if isSoundOn {
                AudioPlayer.shared.playSound(sound: sound)
            }
            
            action()
        }, label: label)
    }
    
    init<T>(send: PassthroughSubject<T, Never>, model: T, with sound: Sound, isSoundOn: Bool = true, label: () -> Label) {
        self.init(
            action: { 
                if isSoundOn {
                    AudioPlayer.shared.playSound(sound: sound)
                }
                
                send.send(model)
            },
            label: label
        )
    }
    
    init(send: PassthroughSubject<Void, Never>, with sound: Sound, isSoundOn: Bool = true, label: () -> Label) {
        self.init(action: {
            if isSoundOn {
                AudioPlayer.shared.playSound(sound: sound)
            }
            
            send.send()
        }, label: label)
    }
}

// MARK: - Custom Functions

extension Button {
    func primaryButton(color: Color, disabled: Bool = false) -> some View {
        self
            .disabled(disabled)
            .buttonStyle(PrimaryButtonStyle(color: color, disabled: disabled))
    }
}
