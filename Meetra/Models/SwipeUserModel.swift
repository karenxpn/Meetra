//
//  SwipeUserModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.03.22.
//

import Foundation
import SwiftUI


struct SwipeUserModel: Identifiable, Codable {
    var id: Int
    var image: String
    var name: String
    var age: Int
    var interests: [UserInterestModel]
    var online: Bool
}

struct SwipeUserViewModel: Identifiable {
    var user: SwipeUserModel
    
    init( user: SwipeUserModel ) {
        self.user = user
    }
    
    var id: Int                 { self.user.id }
    var image: String           { self.user.image }
    var name: String            { self.user.name }
    var age: Int                { self.user.age }
    var online: Bool            { self.user.online }
    var interests: [UserInterestModel]  { self.user.interests }

    
    
    // Card x position
    var x: CGFloat = 0.0
    // Card rotation angle
    var degree: Double = 0.0
}
