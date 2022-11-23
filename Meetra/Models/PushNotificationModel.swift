//
//  PushNotificationModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 16.11.22.
//

import Foundation
struct PushNotificationModel: Codable {
    var title: String
    var content: String
    var type: String
    var chatId: Int
    var user: PushNotificationUserPreview
}

struct PushNotificationUserPreview: Identifiable, Codable {
    var id: Int
    var name: String?
    var online: Bool?
    var lastVisit: String?
    var image: String?
    var blocked: Bool?
    var blockedByMe: Bool?
}
