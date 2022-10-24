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
    
    let sections = ["Анкеты", "Заявки", "Избранное"]
    @State private var selection: String = "Анкеты"
    
    @State private var firstAppearance: Bool = true
    
    @State private var alert: Bool = false
    @Binding var enter: Bool
    
    var body: some View {
        NavigationView {
            ZStack {
                
                if !enter {
                    EnterLocation(alert: $alert)
                } else {
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
                                .zIndex(10)
                            
                            
                            if selection == "Анкеты" {
                                SwipeCards()
                                    .environmentObject(placesVM)
                                    .environmentObject(locationManager)
                            } else if selection == "Заявки" {
                                FriendRequestList()
                            } else {
                                FavouritesList()
                            }
                            
                            Spacer()
                        }
                    }
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
            }).alert(isPresented: $alert) {
                Alert(title: Text(NSLocalizedString("enterLocation", comment: "")),
                      message: Text(NSLocalizedString("enterLocationTerms", comment: "")),
                      primaryButton: .default(Text(NSLocalizedString("accept", comment: "")), action: {
                    enter = true
                    getSwipes()
                }),
                      secondaryButton: .default(Text(NSLocalizedString("reject", comment: "")), action: {
                    enter = false
                }))
            }
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
                    
                    NotificationButton()
                }).onAppear {
                    if enter {
                        getSwipes()
                    }
                }.onChange(of: showFilter) { value in
                    if !value {
                        placesVM.storeFilterValues(location: "swipe")
                    }
                }.onDisappear {
                    firstAppearance = false
                }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    firstAppearance = true
//                    connectSocketAndGetSwipesForFirstAppearance()
                }
                .modifier(NetworkReconnection(action: {
//                    locationManager.getLocationResponse()
                }))
        }.navigationViewStyle(StackNavigationViewStyle())
            .onChange(of: locationManager.status) { value in
                if value == "true" && enter {
                    getSwipes()
                } else {
                    locationManager.stopUpdating()
                }
            }
    }
    
    func getSwipes() {
        placesVM.loading = true
        locationManager.initLocation()
        placesVM.getSwipes()
    }
}

struct Swipes_Previews: PreviewProvider {
    static var previews: some View {
        Swipes(enter: .constant(false))
    }
}
