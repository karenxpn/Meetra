//
//  MessageModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.05.22.
//

import Foundation

struct MessagesListModel: Codable {
    var messages: [MessageModel]
}

struct MessageModel: Identifiable, Codable {
    var id: Int
    var createdAt: String
    var updatedAt: String
    var message: String
    var type: String
    var status: String
    var sender: MessageSenderModel
}

struct MessageSenderModel: Identifiable, Codable {
    var id: Int
    var name: String
    var online: Bool
}
