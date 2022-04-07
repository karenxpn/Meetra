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

struct ProfileEditFieldsViewModel: Codable {
    var fields: ProfileEditFields
    init( fields: ProfileEditFields ) {
        self.fields = fields
    }
    
    var name: String { self.fields.name }
    var bio: String  {
        get { self.fields.bio }
        set { self.fields.bio = newValue }
    }
    
    var job: String {
        get { self.fields.occupation?.job ?? ""}
        set { self.fields.occupation?.job = newValue }
    }
    
    var company: String {
        get { self.fields.occupation?.company ?? ""}
        set { self.fields.occupation?.company = newValue }
    }
    var school: String { self.fields.school ?? "" }
    var gender: String { self.fields.gender }
    var city: String   { self.fields.city ?? ""}
    var showGender: Bool { self.fields.showGender }
    var interests: [String] { self.fields.interests }
}
