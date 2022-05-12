//
//  PhotoMessageContent.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.05.22.
//

import SwiftUI

struct PhotoMessageContent: View {
    @AppStorage("userId") private var userID: Int = 0
    let message: MessageViewModel
    let group: Bool
    
    var body: some View {
        
        VStack( alignment: message.sender.id == userID ? .trailing : .leading) {
            if group && message.sender.id != userID {
                Text( message.sender.name )
                    .foregroundColor(AppColors.proceedButtonColor)
                    .font(.custom("Inter-SemiBold", size: 12))
                    .kerning(0.12)
                    .lineLimit(1)
            }
            
            if message.reptyedTo != nil {
                ReplyedToMessagePreview(replyedTo: message.reptyedTo!)
                    .frame(width: UIScreen.main.bounds.width * 0.5)

            }
            
            if message.content.hasPrefix("https://") {
                ImageHelper(image: message.content, contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.4)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                // view here
            } else {
                if message.status == "pending" && message.sender.id == userID {
                    
                    if let data = try? Data(contentsOf: URL(fileURLWithPath: message.content)), let uiImage = UIImage(data: data) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width * 0.5, height: UIScreen.main.bounds.height * 0.4)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay {
                                ProgressView()
                            }
                    }
                }
                
            }
        }.padding(.vertical, 12)
            .padding(.horizontal, 15)
            .background(message.sender.id == userID ? AppColors.accentColor : AppColors.addProfileImageBG)
            .cornerRadius(message.sender.id == userID ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight], 20)
    }
}

struct PhotoMessageContent_Previews: PreviewProvider {
    static var previews: some View {
        PhotoMessageContent(message: AppPreviewModels.photo_message, group: false)
    }
}
