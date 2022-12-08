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
    @State private var present: Bool = false
    @State private var navigate: Bool = false
    
    @State private var showPopOver: Bool = false
    @State private var showMessageReactions: Bool = false
    let reactions = ["👍", "👎", "❤️", "😂", "🤣", "😡", "😭"]
    
    let message: MessageViewModel
    let group: Bool
    
    var body: some View {
        HStack( alignment: .bottom, spacing: 10) {
            
            if message.sender.id == userID {
                Spacer()
            }
            
            if group && message.sender.id != userID {
                Button {
                    navigate.toggle()
                } label: {
                    ImageHelper(image: message.sender.image, contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }.background(
                    NavigationLink(destination: UserView(userID: message.sender.id), isActive: $navigate, label: {
                        EmptyView()
                    }).hidden()
                )
                
            }
            
            if message.sender.id == userID {
                
                Image(message.status == "sent" ? "sent_icon" : "read_icon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 7)
                
                Text("\(message.createdAt)\(message.isEdited ? NSLocalizedString("edited", comment: "") : "")")
                    .foregroundColor(.gray)
                    .font(.custom("Inter-Regular", size: 8))
            }
            
            
            MessageContent(showReactions: $showMessageReactions, message: message, group: group)
                .scaleEffect(showPopOver ? 0.8 : 1)
                .blur(radius: showPopOver ? 0.7 : 0)
                .animation(.easeInOut, value: showPopOver)
                .onTapGesture(perform: {
                    if message.type == "video" || message.type == "photo" {
                        present.toggle()
                    }
                }).fullScreenCover(isPresented: $present, content: {
                    SingleMediaContentPreview(url: URL(string: message.content)!)
                }).onLongPressGesture(minimumDuration: 0.7, perform: {
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
                                roomVM.reactMessage(messageID: message.id, reaction: reaction)
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
                            roomVM.replyMessage = message
                            showPopOver = false
                        }
                        Divider()
                        
                        if message.type == "text" {
                            MenuButtonsHelper(label: NSLocalizedString("copy", comment: ""), role: .cancel) {
                                UIPasteboard.general.string = message.content
                                showPopOver = false
                            }
                            Divider()
                            if message.sender.id == userID {
                                MenuButtonsHelper(label: NSLocalizedString("edit", comment: ""), role: .cancel) {
                                    roomVM.editingMessage = message
                                    roomVM.message = message.content
                                    showPopOver = false
                                }
                                Divider()
                            }
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
                }.popover(
                    present: $showMessageReactions,
                    attributes: {
                        $0.position = .absolute(
                            originAnchor: .bottom,
                            popoverAnchor: .top
                        )
                    }
                ) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(message.reactions, id: \.id) { reaction in
                            HStack {
                                ImageHelper(image: reaction.user.image, contentMode: .fill)
                                    .frame(width: 15, height: 15)
                                    .clipShape(Circle())
                                
                                Text(reaction.user.name )
                                    .foregroundColor(.black)
                                    .font(.custom("Inter-Regular", size: 12))
                                
                                Spacer()
                                Text(reaction.reaction )
                                    .font(.system(size: 15))
                                
                            }.frame(height: 37)
                                .padding(.horizontal)

                        }
                        
                    }.frame(width: 200)
                        .background(Color.white)
                        .cornerRadius(20)
                        .shadow(color: Color.gray.opacity(0.3), radius: 5, x: 0, y: 5)
                }
            
            
            if message.sender.id != userID {
                Text("\(message.createdAt)\(message.isEdited ? NSLocalizedString("edited", comment: "") : "")")
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
            .offset(x: offset)
            .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                .onChanged({ value in
                    let cur = value.translation.width
                    if message.sender.id == userID {
                        if cur < 0 && cur >= -100 {
                            offset = cur
                        }
                    } else {
                        if cur > 0 && cur <= 100 {
                            offset = cur
                        }
                    }
                    
                }).onEnded({ value in
                    let cur = value.translation.width
                    
                    if message.sender.id == userID && cur <= -100 {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        
                        roomVM.replyMessage = message
                    } else if message.sender.id != userID && cur >= 100 {
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(.success)
                        
                        roomVM.replyMessage = message
                    }
                    offset = 0
                    
                })
            )
            .onAppear {
                if message.status == "sent" && message.sender.id != userID {
                    roomVM.sendReadMessage(messageID: message.id)
                }
            }
    }
}

struct MessageCell_Previews: PreviewProvider {
    static var previews: some View {
        MessageCell(message: AppPreviewModels.message, group: true)
            .environmentObject(ChatRoomViewModel())
    }
}
