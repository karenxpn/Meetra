//
//  MessageContent.swift
//  Meetra
//
//  Created by Karen Mirakyan on 02.05.22.
//

import SwiftUI

struct MessageContent: View {
    
    let message: MessageViewModel
    let group: Bool
    
    var body: some View {
        
        if message.type == "text" {
            TextMessageContent(message: message, group: group)
        } else if message.type == "photo" {
            PhotoMessageContent(message: message, group: group)
        } else if message.type == "video" {
            VideoMessageContent(message: message, group: group)
        } else if message.type == "audio" {
            
        }
    }
}

struct MessageContent_Previews: PreviewProvider {
    static var previews: some View {
        MessageContent(message: AppPreviewModels.message, group: true)
    }
}
