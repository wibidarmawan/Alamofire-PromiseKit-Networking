//
//  PostModel.swift
//  NetworkingTemplate
//
//  Created by tes 123 on 07/03/22.
//

import Foundation

// MARK: - PostModel
struct PostModel: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userID"
        case id, title, body
    }
}

// MARK: - Post Body
struct PostRequestModel: Codable {
    let title: String
    let body: String
    let userID: Int
}

extension PostRequestModel{
    func bodyForAPIRequest() -> [String: Any]{
        var bodyForApi: [String: Any] = [:]
        bodyForApi["userID"] = self.userID
        bodyForApi["title"] = self.title
        bodyForApi["body"] = self.body
        return bodyForApi
    }
}
