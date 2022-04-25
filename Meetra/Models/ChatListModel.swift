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
    var mute: Bool
}

struct ChatModelViewModel: Identifiable {
    var chat: ChatModel
    
    init(chat: ChatModel) {
        self.chat = chat
    }
    
    var id: Int             { self.chat.id }
    var image: String       { self.chat.image }
    var name: String        { self.chat.name }
    
    var mute: Bool {
        get { self.chat.mute }
        set { self.chat.mute = newValue }
    }
}
