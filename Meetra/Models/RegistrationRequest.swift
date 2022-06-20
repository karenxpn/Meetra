//
//  RegistrationRequest.swift
//  Meetra
//
//  Created by Karen Mirakyan on 03.03.22.
//

import Foundation
struct RegistrationRequest: Codable {
    var name: String = ""
    var birthday: String = ""
    var gender: String = ""
    var showGender: Bool = true
    var images: [Data] = []
    var bio: String = ""
    var interests: [String] = []
}
