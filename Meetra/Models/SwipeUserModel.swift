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
}

struct SwipeUserViewModel: Identifiable {
    var user: SwipeUserModel
    
    init( user: SwipeUserModel ) {
        self.user = user
    }
    
    var id: Int                 { self.user.id }
    var image: String           { self.user.image }
    
    
    // Card x position
    var x: CGFloat = 0.0
    // Card rotation angle
    var degree: Double = 0.0
}
