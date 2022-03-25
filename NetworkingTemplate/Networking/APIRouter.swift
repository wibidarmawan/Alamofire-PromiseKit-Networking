//
//  APIRouter.swift
//  NetworkingTemplate
//
//  Created by tes 123 on 04/03/22.
//

import Foundation
import Alamofire

struct ApiRouterStructure: URLRequestConvertible {
    let apiRouter: APIRouter
    
    func headers() -> HTTPHeaders {
        var headersDictionary = [
            "Accept" : "application/json",
            "Origin" : "Some Origin"
        ]
        if let additionalHeaders = apiRouter.additionalHeaders {
            let additionalHeadersDictionary = additionalHeaders.dictionary
            additionalHeadersDictionary.forEach{ (key, value) in
                headersDictionary[key] = value
            }
        }
        return HTTPHeaders(headersDictionary)
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try apiRouter.baseURL.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(apiRouter.path))
        urlRequest.httpMethod = apiRouter.method.rawValue
        urlRequest.timeoutInterval = apiRouter.timeout
        urlRequest.headers = headers()
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = apiRouter.body{
            do {
                let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                urlRequest.httpBody = data
            } catch {
                print(" Fail to generate JSON data")
            }
        }
        
        if let parameters = apiRouter.parameters{
            urlRequest = try apiRouter.encoding.encode(urlRequest, with: parameters)
        }
        print("urlRequest: \(urlRequest)")
        
        return urlRequest
    }
    
}

enum APIRouter {
    // MARK: - Endpoints
    case todos(number: Int)
    case post(postRequestModel: PostRequestModel)
    
    var baseURL: String {
        switch self {
        default: return "https://jsonplaceholder.typicode.com"
        }
    }
    
    var method: HTTPMethod {
        switch self{
        case .todos: return .get
        case .post: return .post
        }
    }
    
    var path: String{
        switch self {
        case let .todos(number):
            return "todos/\(number)"
        case .post:
            return "posts"
        }
    }
    
    var encoding: ParameterEncoding{
        switch method{
        default: return URLEncoding.default
        }
    }

    var parameters: Parameters? {
        switch self{
        case .todos, .post: return nil
        }
    }
    
    var body: Parameters? {
        switch self{
        case .todos: return nil
        case let .post(postRequestModel):
            return postRequestModel.bodyForAPIRequest()
        }
    }
    
    var additionalHeaders: HTTPHeaders? {
        switch self{
        case .todos: return nil
        case.post: return nil
        default: return nil
        }
    }
    
    var timeout: TimeInterval{
        switch self{
        default: return 20
        }
    }
}
