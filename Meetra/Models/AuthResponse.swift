//
//  AuthResponse.swift
//  Meetra
//
//  Created by Karen Mirakyan on 02.03.22.
//

import Foundation
struct AuthResponse: Codable {
    var login: Bool?
    var id: Int
    var accessToken: String
}
