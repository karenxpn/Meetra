//
//  ReactionModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.05.22.
//

import Foundation
struct ReactionModel: Codable {
    var id: Int
    var action: String
    var messageId: Int
    var reaction: String
    var user: ReactionUserModel
}
