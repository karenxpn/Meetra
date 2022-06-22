//
//  PlaceRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 21.03.22.
//

import SwiftUI
import WaterfallGrid

struct PlacesRoomView: View {
    
    @State private var navigate: Bool = false
    var room: PlaceRoom
    
    init(room: PlaceRoom) {
        self.room = room
        if !self.room.users.isEmpty{
            self.room.users.insert(UserPreviewModel(id: 0, image: "", name: "Общий чат", age: 0, online: false), at: 0)
            self.room.users.insert(UserPreviewModel(id: 0, image: "", name: "Локация", age: 0, online: false), at: 2)
        }
    }
    
    var body: some View {
        ScrollView( showsIndicators: false) {
            
            Text( "\(room.chat.members) человек ищут знакомства в \(room.chat.name)" )
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 18))
                .multilineTextAlignment(.center)
                .padding(.top, 15)
            
            WaterfallGrid((0..<room.users.count), id: \.self) { index in
                Group {
                    if index == 0  {
                        Button {
                            navigate.toggle()
                        } label: {
                            
                            VStack {
                                Image("places_chat")
                                    .frame(width: 50, height: 50)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                                
                                Text( "Общий чат")
                                    .foregroundColor(.black)
                                    .font(.custom("Inter-Regular", size: 16))
                            }.padding(.top, 20)
                        }.background(
                            NavigationLink(isActive: $navigate, destination: {
                                ChatRoom(group: true, online: true, lastVisit: "", chatName: room.chat.name, userID: 0, chatID: room.chat.id, left: room.chat.left)
                            }, label: {
                                EmptyView()
                            }).hidden()
                        )
                    } else if index == 2 {
                        Button {
                            
                        } label: {
                            VStack {
                                Image("places_location")
                                    .frame(width: 50, height: 50)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .shadow(radius: 5)
                                
                                Text( "Локация")
                                    .foregroundColor(.black)
                                    .font(.custom("Inter-Regular", size: 16))
                            }.padding(.top, 20)
                        }
                    } else {
                        SinglePlacePreview(user: room.users[index])
                            .padding(.top, index == 1 ? 40 : 0)
                    }
                }
            }.gridStyle(columns: 3, spacing: 20)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 100, trailing: 20))
        }.padding(.top, 1)
    }
}

struct PlacesRoomView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesRoomView(room: AppPreviewModels.placeRoom)
    }
}
