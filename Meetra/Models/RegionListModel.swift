//
//  RegionListModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 19.10.22.
//

import Foundation
struct RegionListModel: Codable {
    var regions: [RegionModel]
}

struct RegionModel: Codable {
    var place_id: String
    var lat: Double
    var lng: Double
    var radius: Double
}
