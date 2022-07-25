//
//  PlaceRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 21.03.22.
//

import Foundation
struct PlaceRoom: Codable {
    var users: [UserPreviewModel]
    var chat: PlaceChat
    var count: Int
}

struct PlaceChat: Codable {
    var id: Int
    var name: String
    var isGroup: Bool
    var members: Int
    var online: Int
    var left: Bool
}
