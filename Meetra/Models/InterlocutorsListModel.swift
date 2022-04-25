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
    // etc
}

struct InterlocutorsViewModel: Identifiable {
    var model: InterlocutorsModel
    
    init(model: InterlocutorsModel) {
        self.model = model
    }
    
    var id: Int         { self.model.id }
    var image: String   { self.model.image }
    
    var online: Bool {
        get { self.model.online }
        set { self.model.online = newValue }
    }
}
