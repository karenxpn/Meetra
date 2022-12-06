//
//  FetchTabUnreadModel.swift
//  Meetra
//
//  Created by Михаил Бебуров on 06.12.2022.
//

import Foundation

struct FetchTabUnreadModel: Codable {
    var unreadMessage: Bool
    var unreadMessageCount: Int
}
