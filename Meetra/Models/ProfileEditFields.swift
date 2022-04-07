//
//  ProfileEditFields.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.04.22.
//

import Foundation
struct ProfileEditFields: Codable {
    var name: String
    var bio: String
    var occupation: OccupationModel?
    var school: String?
    var gender: String
    var city: String?
    var showGender: Bool
    var interests: [String]
}

struct OccupationModel: Codable {
    var job: String
    var company: String
}
