//
//  OnlineResponseModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.04.22.
//

import Foundation
struct OnlineResponseModel: Codable {
    var userId: Int
    var online: Bool
    var lastVisit: String
}

struct OnlineResponseViewModel {
    var model: OnlineResponseModel
    init(model: OnlineResponseModel) {
        self.model = model
    }
    
    var userId: Int         { self.model.userId }
    var online: Bool        { self.model.online }
    var lastVisit: String   { self.model.lastVisit.countTimeBetweenDates() }
}
