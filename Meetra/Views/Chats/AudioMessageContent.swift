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
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (30/25))
    }
    
    init(message: MessageViewModel, group: Bool) {
        self.message = message
        self.group = group
        _audioVM = StateObject(wrappedValue: AudioPlayViewModel(url: URL(string: message.content)!))
    }
    
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
                HStack(alignment: .center, spacing: 10) {
                    
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
                    
                    HStack(alignment: .bottom, spacing: 10) {

                        Text( "Audio Content" )
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 14))
                        
                        if let player = audioVM.player {
                            let seconds = Int(player.duration.truncatingRemainder(dividingBy: 60))
                            
                            Text("\(Int(player.duration / 60)):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")")
                                .foregroundColor(.black)
                                .font(.custom("Inter-Regular", size: 12))
                            
                        }
                    }
                }

            } else {
                HStack(alignment: .bottom, spacing: 2) {
                    
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
                    
                    ForEach(audioVM.soundSamples, id: \.self) { model in
                        BarView(value: self.normalizeSoundLevel(level: model.magnitude), color: model.color)
                    }
                }
            }
        }.padding(.vertical, 12)
                .padding(.horizontal, 15)
            .onAppear {
//                audioVM.visualizeAudio()
            }
    }
}
//
//struct AudioMessageContent_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioMessageContent()
//    }
//}
