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
    
    var sentTime: String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let newDate = dateFormatter.date(from: self.chat.message.createdAt) ?? Date()
        
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        currentDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let currentDate = currentDateFormatter.date(from: dateFormatter.string(from: Date())) ?? Date()
                        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        let string = formatter.localizedString(for: newDate, relativeTo: currentDate)
        
        return newDate == currentDate ? NSLocalizedString("now", comment: "") : string
    }
    
    var mute: Bool {
        get { self.chat.isMuted }
        set { self.chat.isMuted = newValue }
    }
    
    var online: Bool {
        get {
            return self.chat.message.sender.online
            
        }
        set {
            self.chat.message.sender.online = newValue
            
        }
    }
}
