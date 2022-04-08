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
    var school: String
    var gender: String
    var city: String
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
        set {
            self.fields.occupation = OccupationModel(job: self.job.isEmpty ? "" : self.job,
                                                     company: self.company.isEmpty ? "" : self.company)
            self.fields.occupation?.job = newValue
        }
    }
    
    var company: String {
        get { self.fields.occupation?.company ?? ""}
        set {
            self.fields.occupation = OccupationModel(job: self.job.isEmpty ? "" : self.job,
                                                     company: self.company.isEmpty ? "" : self.company)
            self.fields.occupation?.company = newValue
        }
    }
    
    var school: String {
        get { self.fields.school }
        set { self.fields.school = newValue }
        
    }
    var gender: String {
        get { self.fields.gender }
        set { self.fields.gender = newValue }
        
    }
    
    var city: String {
        get { self.fields.city }
        set { self.fields.city = newValue }
    }
    
    var showGender: Bool {
        get { self.fields.showGender }
        set { self.fields.showGender = newValue }
    }
    
    var interests: [String] {
        get { self.fields.interests }
        set { self.fields.interests = newValue }
    }
}
