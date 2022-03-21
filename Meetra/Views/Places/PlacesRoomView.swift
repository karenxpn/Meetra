//
//  PlaceRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 21.03.22.
//

import SwiftUI

struct PlacesRoomView: View {
    
    let room: PlaceRoom
    
    var body: some View {
        ScrollView {
            
            LazyVStack {
                Text( "\(room.usersCount) человек ищут знакомства в Hunt Lounge bar ✨" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 18))
                
                HStack( alignment: .top) {
                    Button {
                        
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
                        }
                    }
                    
                    Spacer()
                    
                    if !room.users.isEmpty {
                        SinglePlacePreview(user: room.users[0])
                    }
                    
                    Spacer()
                    
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
                        }
                    }
                    
                }
                
                
                ForEach(1..<room.users.count, id: \.self ) { index in
                    SinglePlacePreview(user: room.users[index])
                }
                
            }.padding(30)
        }.padding(.top, 1)
    }
}

struct PlacesRoomView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesRoomView(room: PlaceRoom(users: [UserPreviewModel(id: 1, image: "Karen", name: "Karen", online: true),
                                               UserPreviewModel(id: 2, image: "Karen", name: "Karen", online: true),
                                               UserPreviewModel(id: 3, image: "Karen", name: "Karen", online: true),
                                               UserPreviewModel(id: 4, image: "Karen", name: "Karen", online: true),
                                               UserPreviewModel(id: 5, image: "Karen", name: "Karen", online: true),
                                               UserPreviewModel(id: 6, image: "Karen", name: "Karen", online: true),
                                               UserPreviewModel(id: 7, image: "Karen", name: "Karen", online: true)], usersCount: 12))
    }
}
