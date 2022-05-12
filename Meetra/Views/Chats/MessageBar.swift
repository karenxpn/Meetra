//
//  MessageBar.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.05.22.
//

import SwiftUI
import CameraXPN

struct MessageBar: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    
    @EnvironmentObject var roomVM: ChatRoomViewModel
    @StateObject private var audioVM = AudioRecorderViewModel()
    
    @State private var openAttachment: Bool = false
    @State private var openGallery: Bool = false
    @State private var openCamera: Bool = false
    
    var body: some View {
        
        
        VStack( spacing: 0) {
            
            if roomVM.showEditField && roomVM.editingMessage != nil{
                EditMessage( showEditing: $roomVM.showEditField, message: roomVM.editingMessage!)
            }
            
            if audioVM.recording {
                HStack( alignment: .top) {
                    Spacer()
                    Button {
                        audioVM.stopRecord()
                        audioVM.recording = false
                        audioVM.showRecording = false
                        audioVM.showPreview = true
                    } label: {
                        Image("stop_record_icon")
                    }
                }.padding(.trailing, 40)
                    .KeyboardAwarePadding()
            }
            
            HStack {
                if audioVM.showRecording {
                    AudioRecordingView()
                        .environmentObject(audioVM)
                } else if audioVM.showPreview {
                    RecordingPreview(url: audioVM.url)
                } else {
                    Button {
                        openAttachment.toggle()
                    } label: {
                        Image("icon_attachment")
                            .padding([.leading, .vertical], 20)
                    }
                    
                    TextField(NSLocalizedString("messageBarPlaceholder", comment: ""), text: $roomVM.message)
                        .foregroundColor(.black)
                        .font(.custom("Inter-Regular", size: 13))
                        .frame(height: 44)
                        .padding(.horizontal, 20)
                    
                    if !roomVM.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Button {
                            if roomVM.showEditField {
                                roomVM.editMessage()
                            } else {
                                roomVM.sendTextMessage()
                            }
                        } label: {
                            Image("icon_send_message")
                                .padding([.trailing, .vertical], 20)
                        }
                    }
                    
                    
                    Button {
                        if audioVM.permissionStatus == .granted {
                            audioVM.recordAudio()
                        } else {
                            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                        }
                        
                    } label: {
                        Image("icon_voice_message")
                            .padding([.trailing, .vertical], 20)
                    }
                }
            }.frame(height: 96)
                .background(.white)
                .cornerRadius([.topLeft, .topRight], 35)
                .shadow(color: roomVM.showEditField ? Color.clear : Color.gray.opacity(0.1), radius: 2, x: 0, y: -3)
                .KeyboardAwarePadding()
        }
        .confirmationDialog("", isPresented: $openAttachment, titleVisibility: .hidden) {
            Button {
                openGallery.toggle()
            } label: {
                Text(NSLocalizedString("loadFromGallery", comment: ""))
            }
            
            Button {
                openCamera.toggle()
            } label: {
                Text(NSLocalizedString("openCamera", comment: ""))
            }
        }.sheet(isPresented: $openGallery) {
            MessageGallery { content_type, content in
                roomVM.mediaBinaryData = content
                roomVM.getSignedURL(content_type: content_type)
            }
        }.fullScreenCover(isPresented: $openCamera, content: {
            CameraXPN(action: { url, data in
                roomVM.mediaBinaryData = data
                roomVM.getSignedURL(content_type: url.absoluteString.hasSuffix(".mov") ? "video" : "photo")
            }, font: .custom("Inter-SemiBold", size: 14), permissionMessgae: NSLocalizedString("enableAccessForBoth", comment: ""),
                      recordVideoButtonColor: AppColors.accentColor,
                      useMediaContent: NSLocalizedString("userThisMedia", comment: ""))
            
        }).onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "hide_audio_preview"))) { _ in
            audioVM.showPreview = false
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "edit"))) { message in
            if let object = message.object as? [String: MessageViewModel], let message = object["message"] {
                roomVM.editingMessage = message
                roomVM.message = message.content

                withAnimation {
                    roomVM.showEditField = true
                }
            }
        }
    }
}

struct MessageBar_Previews: PreviewProvider {
    static var previews: some View {
        MessageBar()
            .environmentObject(ChatRoomViewModel())
    }
}
