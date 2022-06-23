//
//  InterlocutorsListModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import Foundation
struct InterlocutorsListModel: Codable {
    var interlocutors: [InterlocutorsModel]
}

struct InterlocutorsModel: Identifiable, Codable {
    var id: Int
    var image: String
    var online: Bool
    var isRead: Bool
    var chat: Int
    var name: String
    var lastVisit: String
    var isGroup: Bool
    var left: Bool
}

struct InterlocutorsViewModel: Identifiable {
    var model: InterlocutorsModel
    
    init(model: InterlocutorsModel) {
        self.model = model
    }
    
    var id: Int             { self.model.id }
    var image: String       { self.model.image }
    var chat: Int           { self.model.chat }
    var name: String        { self.model.name }
    var lastVisit: String   { self.model.lastVisit.countTimeBetweenDates() }
    var isGroup: Bool       { self.model.isGroup }
    var left: Bool          { self.model.left }
    
    var read: Bool {
        get { self.model.isRead }
        set { self.model.isRead = newValue }
    }
    
    var online: Bool {
        get { self.model.online }
        set { self.model.online = newValue }
    }
}
