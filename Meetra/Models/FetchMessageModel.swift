//
//  FetchMessageModel.swift
//  Meetra
//
//  Created by Михаил Бебуров on 23.11.2022.
//

import Foundation

struct FetchMessageModel: Codable {
    var chatId: Int
    var message: MessageModel
}
