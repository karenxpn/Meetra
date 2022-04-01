//
//  UserPreviewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 21.03.22.
//

import Foundation
struct UserPreviewModel: Identifiable, Codable {
    var id: Int
    var image: String
    var name: String
    var age: Int
    var online: Bool
}
