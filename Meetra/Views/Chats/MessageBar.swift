//
//  MessageBar.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.05.22.
//

import SwiftUI
import CameraXPN

struct MessageBar: View {
    @EnvironmentObject var roomVM: ChatRoomViewModel
    @StateObject private var audioVM = AudioRecorderViewModel()
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State private var openAttachment: Bool = false
    @State private var openGallery: Bool = false
    @State private var openCamera: Bool = false
        
    var body: some View {
        
        
        VStack( spacing: 0) {
            
            if roomVM.editingMessage != nil {
                BarMessagePreview(message: $roomVM.editingMessage)
            } else if roomVM.replyMessage != nil {
                BarMessagePreview(message: $roomVM.replyMessage)
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
            }
            
            HStack(alignment: .bottom) {
                if audioVM.showRecording {
                    AudioRecordingView()
                        .environmentObject(audioVM)
                } else if audioVM.showPreview {
                    RecordingPreview(url: audioVM.url, duration: Int(audioVM.audioDuration))
                } else {
                    Button {
                        openAttachment.toggle()
                    } label: {
                        Image("icon_attachment")
                            .padding([.leading, .top], 20)
                            .padding(.bottom, 25)
                    }
                    
                    ZStack(alignment: .leading) {
                        
                        if #available(iOS 16.0, *) {
                            TextEditor(text: $roomVM.message)
                                .foregroundColor(.black)
                                .font(.custom("Inter-Regular", size: 13))
                                .background(AppColors.addProfileImageBG)
                                .cornerRadius(10)
                                .scrollContentBackground(.hidden)
                                .focused($isTextFieldFocused)
                        } else {
                            TextEditor(text: $roomVM.message)
                                .foregroundColor(.black)
                                .font(.custom("Inter-Regular", size: 13))
                                .background(AppColors.addProfileImageBG)
                                .cornerRadius(10)
                                .onAppear {
                                    UITextView.appearance().backgroundColor = .clear
                                }
                                .focused($isTextFieldFocused)
                        }
                        
                        Text(roomVM.message == "" ? NSLocalizedString("messageBarPlaceholder", comment: "") : roomVM.message)
                            .opacity(roomVM.message == "" ? 0.5 : 0)
                            .font(.custom("Inter-Regular", size: 13))
                            .padding(.leading, 5)
                            .padding(.bottom, 1)
                            
                    }.padding(.vertical, 20)
                        .padding(.horizontal, 10)
                    
                    if !roomVM.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        Button {
                            if roomVM.editingMessage != nil{
                                roomVM.editMessage()
                            } else {
                                roomVM.sendTextMessage()
                            }
                        } label: {
                            Image("icon_send_message")
                                .padding([.trailing, .top], 20)
                                .padding(.bottom, 25)
                        }
                    } else {
                        Button() {
                            if audioVM.permissionStatus == .granted {
                                audioVM.recordAudio()
                            } else {
                                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                            }
                            
                        } label: {
                            Image("icon_voice_message")
                                .padding([.trailing, .top], 20)
                                .padding(.bottom, 25)
                        }
                    }
                }
            }.frame(height: roomVM.message.numberOfLines > 10 ? 220 : 60+CGFloat(16*roomVM.message.numberOfLines))
                .padding(.bottom, isTextFieldFocused ? 0 : 30)
                .background(.white)
                .cornerRadius([.topLeft, .topRight], (roomVM.editingMessage != nil || roomVM.replyMessage != nil) ? 0 : 35)
                .shadow(color: (roomVM.editingMessage != nil || roomVM.replyMessage != nil) ? Color.clear : Color.gray.opacity(0.1), radius: 2, x: 0, y: -3)
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
        }
    }
}

struct MessageBar_Previews: PreviewProvider {
    static var previews: some View {
        MessageBar()
            .environmentObject(ChatRoomViewModel())
    }
}
