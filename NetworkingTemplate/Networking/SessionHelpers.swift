//
//  SessionHelpers.swift
//  NetworkingTemplate
//
//  Created by tes 123 on 04/03/22.
//

import Foundation
import Alamofire
import PromiseKit

enum InternalError: LocalizedError{
    case unexpected
}

extension Session {
    func request<T: Codable>(_ urlRequestConvertible: ApiRouterStructure) -> Promise<T> {
        return Promise<T> {seal in
            request(urlRequestConvertible).responseDecodable { (response: DataResponse<T, AFError>) in
                guard response.response != nil else {
                    if let error = response.error {
                        seal.reject(error)
                    } else {
                        seal.reject(InternalError.unexpected)
                    }
                    return
                }
                switch response.result {
                case let .success(value):
                    seal.fulfill(value)
                case let .failure(error):
                    seal.reject(error)
                }
            }
            .resume()
        }
    }
    
    func requestData(_ urlRequestConvertible: ApiRouterStructure) -> Promise<Data?> {
        return Promise<Data?> {seal in
            request(urlRequestConvertible).response { response in
                guard response.response != nil else {
                    if let error = response.error {
                        seal.reject(error)
                    } else {
                        seal.reject(InternalError.unexpected)
                    }
                    return
                }
                switch response.result {
                case let .success(value):
                    seal.fulfill(value)
                case let .failure(error):
                    seal.reject(error)
                }
            }
            .resume()
        }
    }
}
