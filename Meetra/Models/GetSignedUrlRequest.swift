//
//  GetSignedUrlRequest.swift
//  Meetra
//
//  Created by Karen Mirakyan on 05.05.22.
//

import Foundation
struct GetSignedUrlRequest: Codable {
    var key: String
    var type: String
    var chatId: Int
}
