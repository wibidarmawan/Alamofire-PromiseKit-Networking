//
//  TodoModel.swift
//  NetworkingTemplate
//
//  Created by tes 123 on 04/03/22.
//

import Foundation

// MARK: - TodoModel
struct TodoModel: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
