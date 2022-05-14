//
//  MessageCell.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.05.22.
//

import SwiftUI
import Popovers

struct MessageCell: View {
    
    @AppStorage("userId") private var userID: Int = 0
    @EnvironmentObject var roomVM: ChatRoomViewModel
    @State private var offset: CGFloat = .zero
    
    @State private var showPopOver: Bool = false
    let reactions = ["👍", "👎", "❤️", "😂", "🤣", "😡", "😭"]
    
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
                .scaleEffect(showPopOver ? 0.8 : 1)
                .blur(radius: showPopOver ? 0.7 : 0)
                .animation(.easeInOut, value: showPopOver)
                .onTapGesture(perform: { })
                .onLongPressGesture(minimumDuration: 0.7, perform: {
                    showPopOver = true
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                })
                .popover(
                    present: $showPopOver,
                    attributes: {
                        $0.position = .absolute(
                            originAnchor: .top,
                            popoverAnchor: message.sender.id == userID ? .bottomRight : .bottomLeft
                        )
                    }
                ) {
                    HStack {
                        
                        ForEach(reactions, id: \.self) { reaction in
                            Button {
                                showPopOver = false
                            } label: {
                                Text(reaction)
                                    .font(.system(size: 28))
                            }
                        }
                        
                    }.padding(.horizontal, 24)
                        .padding(.vertical, 9)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                }
            
                .popover(
                    present: $showPopOver,
                    attributes: {
                        $0.position = .absolute(
                            originAnchor: .bottom,
                            popoverAnchor: .top
                        )
                    }
                ) {
                    VStack(alignment: .leading, spacing: 0) {
                        MenuButtonsHelper(label: NSLocalizedString("answer", comment: ""), role: .cancel) {
                            NotificationCenter.default.post(name: Notification.Name("reply"), object: ["message" : message])
                            showPopOver = false
                        }
                        Divider()
                        
                        if message.type == "text" {
                            MenuButtonsHelper(label: NSLocalizedString("copy", comment: ""), role: .cancel) {
                                UIPasteboard.general.string = message.content
                                showPopOver = false
                            }
                            Divider()
                                                    
                            MenuButtonsHelper(label: NSLocalizedString("edit", comment: ""), role: .cancel) {
                                NotificationCenter.default.post(name: Notification.Name("edit"), object: ["message" : message])
                                showPopOver = false
                            }
                            
                            Divider()
                        }
                        
                        if message.sender.id == userID {
                            MenuButtonsHelper(label: NSLocalizedString("delete", comment: ""), role: .destructive) {
                                roomVM.deleteMessage(messageID: message.id)
                                showPopOver = false
                            }
                        }
                        
                    }.frame(width: 200)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                }
            
            
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
            .padding(.bottom, (roomVM.lastMessageID == message.id && showPopOver) ? UIScreen.main.bounds.height * 0.08 : 0)
        
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
