//
//  NotificationModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 31.05.22.
//

import Foundation
struct NotificationListModel: Codable {
    var notifications: [NotificationModel]
}

struct NotificationModel: Identifiable, Codable {
    var id: Int
    var user: NotificationUserPreview
    var type: String
    var chatId: Int?
    var createdAt: String
}


struct NotificationViewModel: Identifiable {
    var id: Int
    var model: NotificationModel
    
    init(model: NotificationModel) {
        self.model = model
        self.id = model.id
    }
    
    var user: NotificationUserPreview   { self.model.user }
    var type: String                    { self.model.type }
    var createdAt: String               { self.model.createdAt.countTimeBetweenDates() }
    var chat: Int?                      { self.model.chatId }
    var lastVisit: String               { self.model.user.lastVisit.countTimeBetweenDates()}
    var blocked: Bool                   { self.model.user.blocked ?? false }
    var blockedByMe: Bool?              { self.model.user.blockedByMe }
}


struct NotificationUserPreview: Identifiable, Codable {
    var id: Int
    var image: String
    var name: String
    var age: Int
    var online: Bool
    var lastVisit: String
    var blocked: Bool?
    var blockedByMe: Bool?
}
