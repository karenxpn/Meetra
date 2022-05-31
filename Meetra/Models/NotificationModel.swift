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
    var user: UserPreviewModel
    var type: String
    var chat: Int?
    var createdAt: String
}


struct NotificationViewModel: Identifiable {
    var id: Int
    var model: NotificationModel
    
    init(model: NotificationModel) {
        self.model = model
        self.id = model.id
    }
    
    var user: UserPreviewModel  { self.model.user }
    var type: String            { self.model.type }
    var createdAt: String       { self.model.createdAt.countTimeBetweenDates() }
    var chat: Int?              { self.model.chat }
    
}
