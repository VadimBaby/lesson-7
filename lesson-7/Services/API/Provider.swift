//
//  Provider.swift
//  lesson-7
//
//  Created by Вадим Мартыненко on 09.08.2024.
//

import Foundation
import Moya

final class Provider<P>: MoyaProvider<P> where P: TargetType {
    convenience init() {
        let endpointClosure = { (target: P) -> Endpoint in
            let defaultEndpointMapping = MoyaProvider
                .defaultEndpointMapping(for: target)
            
            return defaultEndpointMapping.adding(newHTTPHeaderFields: [:])
        }
        
        let logger = NetworkLoggerPlugin(configuration: NetworkLoggerPlugin.Configuration(logOptions: [.formatRequestAscURL, .errorResponseBody, .verbose]))
        
        let plugins: [PluginType] = [logger]
        
        self.init(endpointClosure: endpointClosure,
                  plugins: plugins)
    }
}
