//
//  Swipes.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.03.22.
//

import SwiftUI

struct Swipes: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject var placesVM = PlacesViewModel()
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var seconds: Int = 0
    
    @State private var showFilter: Bool = false
    @State private var offsetOnDrag: CGFloat = 0
    
    let sections = ["Анкеты", "Заявки", "Избранное"]
    @State private var selection: String = "Анкеты"
    
    @State private var firstAppearance: Bool = true

    var body: some View {
        NavigationView {
            ZStack {
                
                if locationManager.status == "true" && !locationManager.lost_location_socket {
                    
                    if placesVM.loading {
                        Loading()
                    } else {
                        
                        VStack( alignment: .leading, spacing: 20 ) {
                            
                            HStack( spacing: 20 ) {
                                ForEach(sections, id: \.self) { section in
                                    Button {
                                        selection = section
                                        
                                    } label: {
                                        Text( section )
                                            .foregroundColor(selection == section ? .black : .gray)
                                            .font(.custom(selection == section ? "Inter-SemiBold" :"Inter-Regular", size: 16))
                                            .padding(.top)
                                    }
                                }
                            }.padding(.leading, 25)
                            
                            
                            if selection == "Анкеты" {
                                SwipeCards()
                                    .environmentObject(placesVM)
                            } else if selection == "Заявки" {
                                FriendRequestList()
                            } else {
                                FavouritesList()
                            }
                            
                            Spacer()
                        }
                    }
                    
                } else {
                    LostLocationAlert()
                        .environmentObject(locationManager)
                }
                
                FilterUsers(present: $showFilter, gender: $placesVM.gender, status: $placesVM.status, range: $placesVM.ageRange)
                    .offset(y: showFilter ?  -UIScreen.main.bounds.size.height/4: -UIScreen.main.bounds.size.height)
                    .animation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 50, initialVelocity: 0), value: showFilter)
                    .offset(y: offsetOnDrag)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            if value.translation.height < 0 {
                                self.offsetOnDrag = value.translation.height
                            }
                        }).onEnded({ (value) in
                            if value.translation.height < 0 {
                                self.showFilter = false
                                self.offsetOnDrag = 0
                            }
                        }))
                
            }.alert(isPresented: $placesVM.showAlert, content: {
                Alert(title: Text("Error"), message: Text(placesVM.alertMessage), dismissButton: .default(Text("Got it!")))
            })
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Text("Meetra")
                .kerning(0.56)
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 28))
                .padding(10), trailing: HStack( spacing: 20) {
                    Button {
                        showFilter.toggle()
                    } label: {
                        Image("icon_filter")
                            .foregroundColor(showFilter ? AppColors.accentColor : .black)
                    }
                    
                    Button {
                        
                    } label: {
                        Image("icon_ring")
                            .foregroundColor(.black)
                    }
                }).onAppear {
                    locationManager.initLocation()
                    locationManager.getLocationResponse()
                    if firstAppearance {
                        placesVM.getSwipes()
                    }
                    self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

                }.onChange(of: showFilter) { value in
                    if !value {
                        placesVM.storeFilterValues(location: "swipe")
                    }
                }.onReceive(timer) { _ in
                    seconds += 1
                    if seconds % 5 == 0 {
                        if locationManager.status == "true" {
                            locationManager.sendLocation()
                        }
                    }
                    
                }.onDisappear {
                    self.firstAppearance = false
                    self.seconds = 0
                    self.timer.upstream.connect().cancel()
                }.modifier(NetworkReconnection(action: {
                    locationManager.getLocationResponse()
                }))
        }.navigationViewStyle(StackNavigationViewStyle())
            .onChange(of: locationManager.status) { value in
                if value == "true" {
                    locationManager.startUpdating()
                } else {
                    locationManager.stopUpdating()
                }
            }
    }
}

struct Swipes_Previews: PreviewProvider {
    static var previews: some View {
        Swipes()
    }
}
