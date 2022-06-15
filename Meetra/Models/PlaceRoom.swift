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
}

struct PlaceChat: Codable {
    var id: Int
    var name: String
    var isGroup: Bool
    var members: Int
    var online: Int
}

//"chat": {
//        "id": 9,
//        "name": "EVN",
//        "isGroup": true,
//        "members": 3,
//        "online": 0
//    }
