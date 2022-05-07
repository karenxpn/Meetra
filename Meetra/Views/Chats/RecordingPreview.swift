//
//  RecordingPreview.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.05.22.
//

import SwiftUI

struct RecordingPreview: View {
    @StateObject var audioVM: AudioPlayViewModel
    
    init(url: URL) {
        _audioVM = StateObject(wrappedValue: AudioPlayViewModel(url: url))
    }
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 50) / 2 // between 0.1 and 25
        
        return CGFloat(level * (30/25))
    }
    
    
    var body: some View {
        HStack( spacing: 10 ) {
            
            Button {
                audioVM.removeAudio()
            } label: {
                Image("trash_icon")
                    .foregroundColor(.black)
            }
            
            HStack {
                
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
                    
                    ForEach(audioVM.soundSamples, id: \.self) { model in
                        BarView(value: self.normalizeSoundLevel(level: model.magnitude), color: model.color)
                    }
                }
                
                if let player = audioVM.player {
                    let seconds = Int(player.duration.truncatingRemainder(dividingBy: 60))
                    
                    Text("\(Int(player.duration / 60)):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")")
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 12))
                    
                }
            }.frame(width: .greedy)
                        
            Button {
                
            } label: {
                Image("icon_send_message")
                    .padding(.vertical, 20)
            }
            
        }.padding(.horizontal, 20)
        .frame(width: .greedy, height: 96)
            .background(.white)
            .cornerRadius([.topLeft, .topRight], 35)
            .shadow(color: Color.gray.opacity(0.1), radius: 2, x: 0, y: -3)
            .onAppear {
                audioVM.visualizeAudio()
            }
    }
}

//struct RecordingPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        RecordingPreview()
//    }
//}


struct BarView: View {
    let value: CGFloat
    var color: Color = Color.gray
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(color)
                .frame(width: 4, height: value)
        }
    }
}
