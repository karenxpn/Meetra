//
//  PlaceRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 21.03.22.
//

import SwiftUI

struct PlacesRoomView: View {
    
    let room: PlaceRoom
    let users: [[UserPreviewModel]]
    
    init(room: PlaceRoom) {
        self.room = room
        self.users = room.users.custom_split()
    }
    
    var body: some View {
        ScrollView( showsIndicators: false) {
                        
            VStack( alignment: .leading) {
                Text( "\(room.usersCount) человек ищут знакомства в \(room.place)" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 18))
                    .multilineTextAlignment(.center)
                
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
                        }.offset(y: -15)
                    }
                    
                    Spacer()
                    
                    if !users.isEmpty {
                        SinglePlacePreview(user: users[0][0])
                            .offset(x: -10)
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
                        }.offset(y: -15)
                    }
                    
                }.padding(.top, 20)
                
                
                ForEach(1..<users.count, id: \.self ) { index in
                    
                    HStack {
                        
                        ForEach(users[index], id: \.id) { user in
                            HStack {
                                
                                if index % 2 != 0 &&
                                    user.id == users[index].last?.id &&
                                    users[index].first?.id != users[index].last?.id{ Spacer() }
                                
                                SinglePlacePreview(user: user)
                                    
                                if index % 2 != 0 &&
                                    user.id == users[index].first?.id{ Spacer() }
                                
                            }.frame(width: .greedy)
                                .offset(y: CGFloat(-60 * index))
                        }
                        
                    }.frame(minWidth: 0, maxWidth: .infinity)
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
                                               UserPreviewModel(id: 7, image: "Karen", name: "Karen", online: true),
                                               UserPreviewModel(id: 8, image: "Karen", name: "Karen", online: true),
                                               UserPreviewModel(id: 9, image: "Karen", name: "Karen", online: true),
                                               UserPreviewModel(id: 10, image: "Karen", name: "Karen", online: true),
                                               UserPreviewModel(id: 11, image: "Karen", name: "Karen", online: true)], usersCount: 12, place: "EVN"))
    }
}
