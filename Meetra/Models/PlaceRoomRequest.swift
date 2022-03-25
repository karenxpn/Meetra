//
//  PlaceRoomRequest.swift
//  Meetra
//
//  Created by Karen Mirakyan on 22.03.22.
//

import Foundation
struct PlaceRoomRequest: Codable {
    var minAge: Int
    var maxAge: Int
    var gender: String
    var status: String
}
