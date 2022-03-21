//
//  PlaceRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 21.03.22.
//

import Foundation
struct PlaceRoom: Codable {
    var users: [UserPreviewModel]
    var usersCount: Int
    var place: String
}
