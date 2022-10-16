//
//  ChatListModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import Foundation
struct ChatListModel: Codable {
    var chats: [ChatModel]
}

struct ChatModel: Identifiable, Codable {
    var id: Int
    var name: String
    var image: String
    var isGroup: Bool
    var message: MessagePreviewModel
    var isMuted: Bool
    var left: Bool
    var blocked: Bool?
    var hasUnreadMessage: Bool
    
}

struct MessagePreviewModel: Identifiable, Codable {
    var id: Int
    var message: String
    var type: String
    var createdAt: String
    var status: String
    var sender: SenderModel
}

struct SenderModel: Identifiable, Codable {
    var id: Int
    var name: String
    var online: Bool
    var lastVisit: String
}

struct ChatModelViewModel: Identifiable {
    var chat: ChatModel
    
    init(chat: ChatModel) {
        self.chat = chat
    }
    
    var id: Int                         { self.chat.id }
    var image: String                   { self.chat.image }
    var name: String                    { self.chat.name }
    var isGroup: Bool                   { self.chat.isGroup }
    var message: MessagePreviewModel    { self.chat.message}
    var left: Bool                      { self.chat.left }
    
    var sentTime: String                { self.chat.message.createdAt.countTimeBetweenDates() }
    var lastVisit: String               { self.chat.message.sender.lastVisit.countTimeBetweenDates()}
    
    var blocked: Bool                   { self.chat.blocked ?? false }
    
    var mute: Bool {
        get { self.chat.isMuted }
        set { self.chat.isMuted = newValue }
    }
    
    var hasUnreadMessage: Bool          { self.chat.hasUnreadMessage }
    
    var online: Bool {
        get { self.chat.message.sender.online }
        set { self.chat.message.sender.online = newValue }
    }
}
