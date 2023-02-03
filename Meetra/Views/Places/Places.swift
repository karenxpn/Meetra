//
//  Places.swift
//  Meetra
//
//  Created by Karen Mirakyan on 17.03.22.
//

import SwiftUI
import SwiftUIX

struct Places: View {
    
    @EnvironmentObject var locationManager: LocationManager
    @Binding var enter: Bool

    @StateObject var placesVM = PlacesViewModel()
    
    @State private var alert: Bool = false
    
    @State private var showFilter: Bool = false
    @State private var offsetOnDrag: CGFloat = 0

    var body: some View {
        NavigationView {
            ZStack {
                
                if !enter {
                    EnterLocation(alert: $alert)
                } else {
                    if placesVM.loading ||
                        (locationManager.regionState == nil && locationManager.status == "true") {
                        Loading()
                    } else if locationManager.status == "true" &&
                                locationManager.regionState == .inside {
                        
                        if placesVM.loading {
                            Loading()
                        } else {
                            VStack {
                                
                                if placesVM.placeRoom != nil {
                                        PlacesRoomView(room: placesVM.placeRoom!)
                                            .environmentObject(placesVM)
                                }
                            }
                        }
                    } else if locationManager.status == "use" && locationManager.alwaysRequested {
                        AlwaysLocationAlert()
                            .environmentObject(locationManager)
                    } else {
                        LostLocationAlert()
                            .environmentObject(locationManager)
                            .environmentObject(placesVM)
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
            })
            .alert(isPresented: $alert) {
                Alert(title: Text(NSLocalizedString("enterLocation", comment: "")),
                      message: Text(NSLocalizedString("enterLocationTerms", comment: "")),
                      primaryButton: .default(Text(NSLocalizedString("accept", comment: "")), action: {
                    enter = true
                    getRoom()
                }),
                      secondaryButton: .default(Text(NSLocalizedString("reject", comment: "")), action: {
                    enter = false
                }))
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: HStack {
                Text("Meetra")
                    .kerning(0.56)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Black", size: 28))
                .padding(10)}, trailing: HStack( spacing: 20) {
                    Button {
                        showFilter.toggle()
                    } label: {
                        Image("icon_filter")
                            .foregroundColor(showFilter ? AppColors.accentColor : .black)
                    }
                    
                    NotificationButton()
                }).onAppear {
                    AppAnalytics().logScreenEvent(viewName: "\(Places.self)")
                    if enter {
                        placesVM.placeRoom = nil
                        getRoom()
                    }
                }.onChange(of: showFilter) { value in
                    if !value {
                        placesVM.storeFilterValues(location: "place")
                    }
                }.onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                    getRoom()
                }
                .modifier(NetworkReconnection(action: {
                    getRoom()
                }))

        }.navigationViewStyle(StackNavigationViewStyle())
            .onChange(of: locationManager.status) { value in
                if value == "true" && enter {
                    getRoom()
                } else {
                    locationManager.stopUpdating()
                }
            }
    }
    
    func getRoom() {
        placesVM.loading = true
        locationManager.initLocation()
        placesVM.getRoom()
        if placesVM.users.count == 0 {
            placesVM.getSwipes()
        }
    }
}

struct Places_Previews: PreviewProvider {
    static var previews: some View {
        Places(enter: .constant(false))
    }
}
