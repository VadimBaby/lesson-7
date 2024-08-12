//
//  Token.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation

struct Token {
    let accessToken: String
    let tokenType: String
}

extension Token {
    init(serverEntity: ServerToken) {
        self.init(
            accessToken: serverEntity.accessToken.orEmpty,
            tokenType: serverEntity.tokenType.orEmpty
        )
    }
}
