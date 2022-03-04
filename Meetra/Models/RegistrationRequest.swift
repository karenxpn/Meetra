//
//  RegistrationRequest.swift
//  Meetra
//
//  Created by Karen Mirakyan on 03.03.22.
//

import Foundation
struct RegistrationRequest: Codable {
    var phone: String = ""
    var name: String = ""
    var birthday: String = ""
    var gender: String = ""
    var private_gender: Bool = false
     var images: [String] = []
    // var bio: String = ""
    // var interests: [Int] = []
}
