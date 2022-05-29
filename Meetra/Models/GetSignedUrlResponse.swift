//
//  GetSignedUrlResponse.swift
//  Meetra
//
//  Created by Karen Mirakyan on 05.05.22.
//

import Foundation
struct GetSignedUrlResponse: Codable {
    var url: String
    var message: MessageModel
}
