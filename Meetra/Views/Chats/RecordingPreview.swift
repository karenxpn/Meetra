//
//  RecordingPreview.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.05.22.
//

import SwiftUI

struct RecordingPreview: View {
    @EnvironmentObject var roomVM: ChatRoomViewModel
    @StateObject var audioVM: AudioPlayViewModel
    let url: URL
    let duration: Int
    
    init(url: URL, duration: Int) {
        self.url = url
        self.duration = duration
        _audioVM = StateObject(wrappedValue: AudioPlayViewModel(url: url, sampels_count: Int(UIScreen.main.bounds.width * 0.5 / 6)))
        print(duration)
    }
    
    private func normalizeSoundLevel(level: Float) -> CGFloat {
        let level = max(0.2, CGFloat(level) + 70) / 2 // between 0.1 and 35
        
        return CGFloat(level * (40/35))
    }
    
    
    var body: some View {
        HStack( spacing: 10 ) {
            
            Button {
                audioVM.pauseAudio()
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
                
                Text("\(duration / 60):\(duration % 60 < 10 ? "0\(duration % 60)" : "\(duration % 60)")")
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                
            }.frame(width: .greedy)
            
            Button {
                sendAudio()
            } label: {
                Image("icon_send_message")
                    .padding(.vertical, 20)
            }
            
        }.padding(.horizontal, 20)
            .frame(width: .greedy, height: 96)
            .background(.white)
            .cornerRadius([.topLeft, .topRight], roomVM.replyMessage != nil ? 0 : 35)
            .shadow(color: roomVM.replyMessage != nil ? Color.clear : Color.gray.opacity(0.1), radius: 2, x: 0, y: -3)
            .onAppear {
                audioVM.visualizeAudio()
            }
    }
    
    func sendAudio() {
        do {
            let data = try Data(contentsOf: audioVM.url)
            roomVM.mediaBinaryData = data
            roomVM.duration = "\(duration / 60):\(duration % 60 < 10 ? "0\(duration % 60)" : "\(duration % 60)")"
            
            
            roomVM.getSignedURL(content_type: "audio")
        } catch {
            print(error)
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
            Rectangle()
                .fill(color)
                .cornerRadius([.topLeft, .topRight], 10)
                .frame(width: 4, height: value)
        }
    }
}
