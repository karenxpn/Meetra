//
//  Swipes.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.03.22.
//

import SwiftUI

struct Swipes: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @StateObject var placesVM = PlacesViewModel()
    
    @State private var showFilter: Bool = false
    @State private var offsetOnDrag: CGFloat = 0
    
    let sections = ["Заявки", "Избранное"]
    @State private var selection: String = "Заявки"
    
    @State private var firstAppearance: Bool = true
    
    @State private var alert: Bool = false
    @Binding var enter: Bool
    
    var hasfriendRequest: Bool
    var friendRequestCount: Int
    
    var body: some View {
        NavigationView {
            ZStack {
                        
                        VStack( alignment: .leading, spacing: 20 ) {
                            
                            HStack( spacing: 20 ) {
                                ForEach ( 0..<sections.count, id: \.self ) { id in
                                    Button {
                                        selection = sections[id]
                                    } label: {
                                        HStack (spacing: 5) {
                                            Text( sections[id] )
                                                .foregroundColor(selection == sections[id] ? .black : .gray)
                                                .font(.custom(selection == sections[id] ? "Inter-SemiBold" :"Inter-Regular", size: 16))
                                                .padding(.top)
                                            if id == 0 && hasfriendRequest {
                                                ZStack {
                                                    Circle()
                                                        .fill(.red)
                                                        .frame(width: 17, height: 17)
                                                    
                                                    Text(String(friendRequestCount))
                                                        .foregroundColor(.white)
                                                        .font(.custom("Inter-Bold", size: 10))
                                                }.padding(.top)
                                            }
                                        }
                                    }
                                }
                            }.padding(.leading, 25)
                                .zIndex(10)
                            
                            
                            if selection == "Заявки" {
                                FriendRequestList()
                            } else {
                                FavouritesList()
                            }
                            
                            Spacer()
                        }
                
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Text("Meetra")
                .kerning(0.56)
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 28))
                .padding(10), trailing: HStack( spacing: 20) {
                    NotificationButton()
                }).onDisappear {
                    firstAppearance = false
                }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    firstAppearance = true
//                    connectSocketAndGetSwipesForFirstAppearance()
                }
                .modifier(NetworkReconnection(action: {
//                    locationManager.getLocationResponse()
                }))
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct Swipes_Previews: PreviewProvider {
    static var previews: some View {
        Swipes(enter: .constant(false), hasfriendRequest: true, friendRequestCount: 10).environmentObject(LocationManager())
    }
}
