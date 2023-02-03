//
//  PlaceRoom.swift
//  Meetra
//
//  Created by Karen Mirakyan on 21.03.22.
//

import SwiftUI
import WaterfallGrid

struct PlacesRoomView: View {
    
    @EnvironmentObject var placesVM: PlacesViewModel
    @State private var navigate: Bool = false
    var room: PlaceRoom
    @State private var switcher: Bool = false
    
    var body: some View {
        ScrollView( showsIndicators: false) {
            
            Text( "\(room.count) человек ищут знакомства в \(room.chat.name)" )
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 18))
                .multilineTextAlignment(.center)
                .padding(.top, 15)
            
            if !placesVM.placeUsers.isEmpty {
                let columns: [GridItem] = Array(repeating: .init(.flexible(), alignment: .top), count: 3)
                LazyVGrid(columns: columns) {
                    
                    // first columnn with grop chat check
                    LazyVStack(spacing: 20) {
                        ForEach(0..<placesVM.placeUsers[0].count, id: \.self) { index in
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
                                        ChatRoom(group: true,
                                                 online: true,
                                                 lastVisit: "",
                                                 chatName: room.chat.name,
                                                 chatImage: "",
                                                 userID: 0,
                                                 chatID: room.chat.id,
                                                 left: room.chat.left,
                                                 blocked: false,
                                                 blockedByMe: false)
                                    }, label: {
                                        EmptyView()
                                    }).hidden()
                                )
                            } else {
                                SinglePlacePreview(user: placesVM.placeUsers[0][index])
                                    .onAppear {
                                        if placesVM.placeUsers[0][index].id == placesVM.placeRoom?.users.last?.id && !placesVM.loadingRoomPage {
                                            placesVM.getRoom()
                                        }
                                    }
                            }
                        }
                    }
                    
                    // end of first column
                    
                    //                // second column
                    LazyVStack(spacing: 20) {
                        ForEach(0..<placesVM.placeUsers[1].count, id: \.self) { index in
                            
                            SinglePlacePreview(user: placesVM.placeUsers[1][index])
                                .padding(.top, index == 0 ? 40 : 0)
                                .onAppear {
                                    if placesVM.placeUsers[1][index].id == placesVM.placeRoom?.users.last?.id && !placesVM.loadingRoomPage {
                                        placesVM.getRoom()
                                    }
                                }
                        }
                    }
                    //
                    //                // end of second column
                    //
                    // third column
                    LazyVStack(spacing: 20) {
                        ForEach(0..<placesVM.placeUsers[2].count, id: \.self) { index in
                            if index == 0  {
                                Button {
                                    switcher.toggle()
                                } label: {
                                    VStack {
                                        Image("profiles_icon")
                                            .frame(width: 50, height: 50)
                                            .background(.white)
                                            .foregroundColor(.black)
                                            .clipShape(Circle())
                                            .shadow(radius: 5)
                                        
                                        Text( "Свайпы")
                                            .foregroundColor(.black)
                                            .font(.custom("Inter-Regular", size: 16))
                                    }.padding(.top, 20)
                                }.background(
                                    NavigationLink(isActive: $switcher, destination: {
                                        SwipeCards()
                                            .environmentObject(placesVM)
                                    }, label: {
                                        EmptyView()
                                    }).hidden()
                                )
                            } else {
                                SinglePlacePreview(user: placesVM.placeUsers[2][index])
                                    .onAppear {
                                        if placesVM.placeUsers[2][index].id == placesVM.placeRoom?.users.last?.id && !placesVM.loadingRoomPage {
                                            placesVM.getRoom()
                                        }
                                    }
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 100, trailing: 20))
            }
        }.padding(.top, 1)
    }
}

struct PlacesRoomView_Previews: PreviewProvider {
    static var previews: some View {
        PlacesRoomView(room: AppPreviewModels.placeRoom)
    }
}
