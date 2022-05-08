//
//  AudioRecordingView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.05.22.
//

import SwiftUI

struct AudioRecordingView: View {
    @EnvironmentObject var audioVM: AudioRecorderViewModel
    @EnvironmentObject var roomVM: ChatRoomViewModel
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var duration: Int = 0

    var body: some View {
        
        HStack( alignment: .center) {
            
            Circle()
                .fill(.red)
                .frame(width: 6, height: 6)
            
            Text("\(duration / 60):\(duration % 60 < 10 ? "0\(duration % 60)" : "\(duration % 60)")")
                .foregroundColor(.black)
                .font(.custom("Inter-Regular", size: 12))
                .onReceive(timer) { _ in
                    duration += 1
                }
            
            Spacer()
            
            Button {
                audioVM.stopRecord()
                timer.upstream.connect().cancel()
                audioVM.showRecording = false
                audioVM.recording = false
            } label: {
                Text( NSLocalizedString("cancel", comment: ""))
                    .foregroundColor(AppColors.accentColor)
                    .font(.custom("Inter-SemiBold", size: 14))
            }
            
            
            Spacer()
            
            
            Button {
                audioVM.stopRecord()
                timer.upstream.connect().cancel()
                audioVM.showRecording = false
                audioVM.recording = false
                
                sendAudio()
            } label: {
                ZStack {
                    Circle()
                        .fill(AppColors.addProfileImageBG)
                        .frame(width: 70, height: 70)
                    
                    Image("send_audio_message")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 52, height: 52)
                }
            }
            
        }.padding(.leading, 40)
            .padding([.vertical, .trailing])
            .onDisappear {
                timer.upstream.connect().cancel()
            }
    }
    
    func sendAudio() {
        do {
            let data = try Data(contentsOf: audioVM.url)
            roomVM.mediaBinaryData = data
            
            roomVM.getSignedURL(content_type: "audio")
        } catch {
            print(error)
        }
    }
}

struct AudioRecordingView_Previews: PreviewProvider {
    static var previews: some View {
        AudioRecordingView()
            .environmentObject(AudioRecorderViewModel())
    }
}
