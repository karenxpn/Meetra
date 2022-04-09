//
//  ProfileImageList.swift
//  Meetra
//
//  Created by Karen Mirakyan on 09.04.22.
//

import Foundation
struct ProfileImageList: Codable {
    var images: [ProfileImageModel]
}

struct ProfileImageModel: Identifiable, Codable {
    var id: Int
    var type: String
    var image: String
}
