//
//  ProfileEditFields.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.04.22.
//

import Foundation
struct ProfileEditFields: Codable {
    var bio: String
    var fields: [ProfileFields]
    var interests: [String]
    
}

struct ProfileFields: Codable, Identifiable {
    var id: Int
    var name: String
    var value: String
}
