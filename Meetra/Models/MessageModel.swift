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

struct MessageViewModel: Identifiable {
    var message: MessageModel
    init(message: MessageModel) {
        self.message = message
    }
    
    var id: Int             { self.message.id }
    var createdAt: String   { self.message.createdAt }
    
    var updatedAt: String   {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let newDate = dateFormatter.date(from: self.message.updatedAt) ?? Date()
        
        let currentDateFormatter = DateFormatter()
        currentDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        currentDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let currentDate = currentDateFormatter.date(from: dateFormatter.string(from: Date())) ?? Date()
                        
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        let string = formatter.localizedString(for: newDate, relativeTo: currentDate)
        
        return newDate == currentDate ? NSLocalizedString("now", comment: "") : string
    }
    
    var content: String     { self.message.message}
    var type: String        { self.message.type }
    var status: String      { self.message.status }
    var sender: MessageSenderModel  { self.message.sender }
}
