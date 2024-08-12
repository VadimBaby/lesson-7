//
//  AuthEndpoint.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation
import Moya

enum AuthEndpoint: TargetType {
    case postToken
    
    var baseURL: URL {
        guard let url = URL(string: "https://pfa.foreca.com") else {
            fatalError("Incorrect \(self) baseURL!")
        }
        
        return url
    }
    
    var path: String {
        "/authorize/token"
    }
    
    var method: Moya.Method {
        .post
    }
    
    var task: Moya.Task {
        var params = [String : Any]()
        params["user"] = APISecureKeys.login
        params["password"] = APISecureKeys.password
        return .requestCompositeParameters(
            bodyParameters: params,
            bodyEncoding: JSONEncoding.default,
            urlParameters: ["expire_hours" : -1]
        )
    }
    
    var headers: [String : String]? { nil }
}
