//
//  ConnectionSettings.swift
//  NetworkingTemplate
//
//  Created by tes 123 on 04/03/22.
//

import Foundation
import Alamofire

struct ConnectionSettings {
}

extension ConnectionSettings{
    static func sessionManager() -> Session {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        configuration.urlCache = nil
        
        let sessionManager = Session(configuration: configuration, startRequestsImmediately: false)
        return sessionManager
    }
}
