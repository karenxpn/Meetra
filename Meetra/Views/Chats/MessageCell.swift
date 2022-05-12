//
//  MessageCell.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.05.22.
//

import SwiftUI

struct MessageCell: View {
    
    @AppStorage("userId") private var userID: Int = 0
    @EnvironmentObject var roomVM: ChatRoomViewModel
    @State private var offset: CGFloat = .zero
    
    let message: MessageViewModel
    let group: Bool
    
    var body: some View {
        HStack( alignment: .bottom, spacing: 10) {
            
            if message.sender.id == userID {
                Spacer()
            }
            
            if group && message.sender.id != userID {
                ImageHelper(image: "image", contentMode: .fill)
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())
                
            }
            
            if message.sender.id == userID {
                
                Image(message.status == "sent" ? "sent_icon" : "read_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 7)
                
                Text("\(message.updatedAt)\(message.isEdited ? NSLocalizedString("edited", comment: "") : "")")
                    .foregroundColor(.gray)
                    .font(.custom("Inter-Regular", size: 8))
            }
            
            MessageContent(message: message, group: group)
                .onTapGesture {
                    print("tap")
                }.contextMenu(menuItems: {
                    Button {
                        NotificationCenter.default.post(name: Notification.Name("reply"), object: ["message" : message])
                    } label: {
                        Text(NSLocalizedString("answer", comment: ""))
                    }
                    
                    Button {
                    } label: {
                        Text(NSLocalizedString("copy", comment: ""))
                        
                    }
                    
                    if message.type == "text" {
                        Button {
                            NotificationCenter.default.post(name: Notification.Name("edit"), object: ["message" : message])
                            
                        } label: {
                            Text(NSLocalizedString("edit", comment: ""))
                            
                        }
                    }
                    
                    Button(role: .destructive) {
                        roomVM.deleteMessage(messageID: message.id)
                    } label: {
                        Text(NSLocalizedString("delete", comment: ""))
                    }
                })
            
            
            if message.sender.id != userID {
                Text("\(message.updatedAt)\(message.isEdited ? NSLocalizedString("edited", comment: "") : "")")
                    .foregroundColor(.gray)
                    .font(.custom("Inter-Regular", size: 8))
            }
            
            if message.sender.id != userID {
                Spacer()
            }
        }.padding(.horizontal, 20)
            .padding(message.sender.id == userID ? .leading : .trailing, UIScreen.main.bounds.width * 0.05)
            .padding(.vertical, 8)
            .offset(x: offset)
//            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
//                .onChanged({ value in
//                    let cur = value.translation.width
//                    print(cur)
//                    if message.sender.id == userID {
//                        if cur < 0 && cur >= -80 {
//                            offset = cur
//                        }
//                    } else {
//                        if cur > 0 && cur <= 80 {
//                            offset = cur
//                        }
//                    }
//
//                }).onEnded({ value in
//                    if offset <= -80 || offset >= 80 {
//                        let generator = UINotificationFeedbackGenerator()
//                        generator.notificationOccurred(.success)
//
//                        print("need some action")
//                    }
//                    offset = 0
//
//                })
//            )

    }
}

struct MessageCell_Previews: PreviewProvider {
    static var previews: some View {
        MessageCell(message: AppPreviewModels.message, group: true)
            .environmentObject(ChatRoomViewModel())
    }
}
