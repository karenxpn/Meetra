//
//  GetMessageSignedUrlRequest.swift
//  Meetra
//
//  Created by Karen Mirakyan on 05.05.22.
//

import Foundation
struct GetMessageSignedUrlRequest: Codable {
    var key: String
    var type: String
    var chatId: Int
    var repliedTo: Int?
    var duration: String?
}
