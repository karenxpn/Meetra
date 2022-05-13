//
//  AudioMessageContent.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.05.22.
//

import SwiftUI
import AVFoundation
import AVKit

struct AudioMessageContent: View {
    @StateObject private var audioVM: AudioPlayViewModel
    @AppStorage("userId") private var userID: Int = 0
    let message: MessageViewModel
    let group: Bool
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 70) / 2 // between 0.1 and 35
        
        return CGFloat(level * (40/35))
    }
    
    init(message: MessageViewModel, group: Bool) {
        self.message = message
        self.group = group
        _audioVM = StateObject(wrappedValue: AudioPlayViewModel(url: URL(string: message.content)!, sampels_count: Int(UIScreen.main.bounds.width * 0.4 / 6)))
    }
    
    var body: some View {
        VStack( alignment: message.sender.id == userID && message.reptyedTo == nil ? .trailing : .leading ) {
            if group && message.sender.id != userID {
                Text( message.sender.name )
                    .foregroundColor(AppColors.proceedButtonColor)
                    .font(.custom("Inter-SemiBold", size: 12))
                    .kerning(0.12)
                    .lineLimit(1)
            }
            
            if message.reptyedTo != nil {
                ReplyedToMessagePreview(senderID: message.sender.id, repliedTo: message.reptyedTo!, contentType: "audio")
                    .frame(width: UIScreen.main.bounds.width * 0.4)
            }
            
            LazyHStack(alignment: .center, spacing: 10) {
                
                Button {
                    if audioVM.isPlaying {
                        audioVM.pauseAudio()
                    } else {
                        audioVM.playAudio()
                    }
                } label: {
                    Image(!(audioVM.isPlaying) ? "play_icon" : "pause_icon" )
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                
                HStack(alignment: .bottom, spacing: 2) {
                    if audioVM.soundSamples.isEmpty {
                        ProgressView()
                    } else {
                        ForEach(audioVM.soundSamples, id: \.self) { model in
                            BarView(value: self.normalizeSoundLevel(level: model.magnitude), color: model.color)
                        }
                    }
                }.frame(width: UIScreen.main.bounds.width * 0.4)
                
                if audioVM.duration != "0:0" {
                    Text(audioVM.duration)
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12))
                }
            }
        }.padding(.vertical, 8)
    }
}
//
//struct AudioMessageContent_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioMessageContent()
//    }
//}
