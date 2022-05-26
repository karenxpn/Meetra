//
//  MessageReactionModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 26.05.22.
//

import Foundation
struct MessageReactionModel: Identifiable, Codable {
    var id: Int
    var reaction: String
    var user: ReactionUserModel
}


struct ReactionUserModel: Identifiable, Codable {
    var id: Int
    var name: String
    var image: String
}
