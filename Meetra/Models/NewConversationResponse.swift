//
//  NewConversationResponse.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.05.22.
//

import Foundation
struct NewConversationResponse: Codable {
    var userImage: String
    var interlocutorImage: String
    var groupMembers: Int
}
