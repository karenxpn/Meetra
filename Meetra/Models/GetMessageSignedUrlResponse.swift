//
//  GetMessageSignedUrlResponse.swift
//  Meetra
//
//  Created by Karen Mirakyan on 05.05.22.
//

import Foundation
struct GetMessageSignedUrlResponse: Codable {
    var url: String
    var message: MessageModel
}
