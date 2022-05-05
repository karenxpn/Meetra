//
//  MessageBar.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.05.22.
//

import SwiftUI

struct MessageBar: View {
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @EnvironmentObject var roomVM: ChatRoomViewModel
    
    @State private var openAttachment: Bool = false
    @State private var openGallery: Bool = false
    
    var body: some View {
        HStack {
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
                    roomVM.sendTextMessage()
                } label: {
                    Image("icon_send_message")
                        .padding([.trailing, .vertical], 20)
                }
            }
            

            Button {
                
            } label: {
                Image("icon_voice_message")
                    .padding([.trailing, .vertical], 20)
            }
        }.frame(height: 96)
        .background(.white)
            .cornerRadius([.topLeft, .topRight], 35)
            .shadow(color: Color.gray.opacity(0.1), radius: 2, x: 0, y: -3)
            .KeyboardAwarePadding()
            .confirmationDialog("", isPresented: $openAttachment, titleVisibility: .hidden) {
                Button {
                    openGallery.toggle()
                } label: {
                    Text(NSLocalizedString("loadFromGallery", comment: ""))
                }

            }.sheet(isPresented: $openGallery) {
                MessageGallery { content_type, content in
                    roomVM.mediaBinaryData = content
                    roomVM.getSignedURL(content_type: content_type)
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
