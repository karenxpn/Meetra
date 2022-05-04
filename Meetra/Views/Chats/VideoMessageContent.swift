//
//  VideoMessageContent.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.05.22.
//

import SwiftUI
import AVKit

struct AVPlayerControllerRepresented : UIViewControllerRepresentable {
    var player : AVPlayer
    
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = false
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}

struct VideoMessageContent: View {
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
            
            if message.content.hasPrefix("https://") {
                let player = AVPlayer(url:  URL(string: message.content)!)
                
                VideoPlayer(player: player)
                    .frame(width: UIScreen.main.bounds.width * 0.5,
                           height: UIScreen.main.bounds.height * 0.4)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    // view here
            } else {
                // store video locally and present it

            }
        }.padding(.vertical, 12)
            .padding(.horizontal, 15)
            .background(message.sender.id == userID ? AppColors.accentColor : AppColors.addProfileImageBG)
            .cornerRadius(message.sender.id == userID ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight], 20)
    }
}

struct VideoMessageContent_Previews: PreviewProvider {
    static var previews: some View {
        VideoMessageContent(message: AppPreviewModels.video_message, group: true)
    }
}
