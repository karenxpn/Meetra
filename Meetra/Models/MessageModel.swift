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
    var isEdited: Bool
    var duration: String?
    var repliedTo: RepliedModel?
    var sender: MessageSenderModel
    var reactions: [MessageReactionModel]
}

struct MessageSenderModel: Identifiable, Codable {
    var id: Int
    var name: String
    var online: Bool
}

struct RepliedModel: Identifiable, Codable {
    var id: Int
    var message: String
    var type: String
    var sender: ReplySenderModel
}

struct ReplySenderModel: Codable {
    var name: String
}

struct MessageViewModel: Identifiable {
    var message: MessageModel
    init(message: MessageModel) {
        self.message = message
    }
    
    var id: Int             { self.message.id }
    var createdAt: String   { self.message.createdAt }
    var duration: String?    { self.message.duration }
    
    var isEdited: Bool {
        get { self.message.isEdited }
        set { self.message.isEdited = newValue }
    }
    
    var updatedAt: String   { self.message.updatedAt.countTimeBetweenDates() }
    
    var reptyedTo: RepliedModel? { self.message.repliedTo }
    
    var reactions: [MessageReactionModel] {
        get { self.message.reactions }
        set { self.message.reactions = newValue }
    }
    
    var content: String {
        get { self.message.message }
        set { self.message.message = newValue }
    }
    
    var type: String        { self.message.type }
    var status: String {
        get { self.message.status }
        set { self.message.status = newValue }
        
    }
    var sender: MessageSenderModel  { self.message.sender }
}
