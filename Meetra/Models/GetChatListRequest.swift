//
//  GetChatListRequest.swift
//  Meetra
//
//  Created by Karen Mirakyan on 28.04.22.
//

import Foundation
struct GetChatListRequest: Codable {
    var page: Int
    var search: String
}
