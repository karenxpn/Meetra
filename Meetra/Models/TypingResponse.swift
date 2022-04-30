//
//  TypingResponse.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.04.22.
//

import Foundation
struct TypingResponse: Codable {
    var chatId: Int
    var typing: Bool
    var user: TypingUserModel
}

struct TypingUserModel: Identifiable, Codable {
    var id: Int
    var name: String
}
