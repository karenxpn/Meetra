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
}

struct InterlocutorsViewModel: Identifiable {
    var model: InterlocutorsModel
    
    init(model: InterlocutorsModel) {
        self.model = model
    }
    
    var id: Int         { self.model.id }
    var image: String   { self.model.image }
    var chat: Int       { self.model.chat }
    var read: Bool      { self.model.isRead }
    
    var online: Bool {
        get { self.model.online }
        set { self.model.online = newValue }
    }
}
