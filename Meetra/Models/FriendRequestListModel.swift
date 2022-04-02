//
//  FriendRequestListModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.04.22.
//

import Foundation
struct FriendRequestListModel: Codable {
    var requests: [FriendRequestModel]
}

struct FriendRequestModel: Identifiable, Codable {
    var id: Int
    var image: String
    var name: String
    var age: Int
    var school: String
    var location: String
    var message: String
}
