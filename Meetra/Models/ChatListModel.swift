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
    var online: Bool
    var isGroup: Bool
    var message: MessagePreviewModel
    var isRead: Bool
    var isMuted: Bool
    
}

struct MessagePreviewModel: Identifiable, Codable {
    var id: Int
    var message: String
    var type: String
    var createdAt: String
}

struct ChatModelViewModel: Identifiable {
    var chat: ChatModel
    
    init(chat: ChatModel) {
        self.chat = chat
    }
    
    var id: Int                         { self.chat.id }
    var image: String                   { self.chat.image }
    var name: String                    { self.chat.name }
    var online: Bool                    { self.chat.online }
    var isGroup: Bool                   { self.chat.isGroup }
    var read: Bool                      { self.chat.isRead }
    var message: MessagePreviewModel    { self.chat.message}
    
    var mute: Bool {
        get { self.chat.isMuted }
        set { self.chat.isMuted = newValue }
    }
}
