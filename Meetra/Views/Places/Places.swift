//
//  Places.swift
//  Meetra
//
//  Created by Karen Mirakyan on 17.03.22.
//

import SwiftUI
import SwiftUIX

struct Places: View {
    
    @StateObject private var locationManager = LocationManager()
    @StateObject var placesVM = PlacesViewModel()
    
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var seconds: Int = 0
    
    @State private var showFilter: Bool = false
    @State private var offsetOnDrag: CGFloat = 0
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                
                if locationManager.status {
                    
                    VStack {
                        
                        if placesVM.placeRoom != nil {
                            PlacesRoomView(room: placesVM.placeRoom)
                        }
                        
                    }.onReceive(timer) { _ in
                        seconds += 1
                        if seconds % 5 == 0 {
                            placesVM.sendLocation(lat: locationManager.location?.latitude ?? 0,
                                                  lng: locationManager.location?.longitude ?? 0)
                        }
                        
                    }.onAppear {
                        self.timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
                    }.onDisappear {
                        self.seconds = 0
                        self.timer.upstream.connect().cancel()
                    }
                    
                } else {
                    LostLocationAlert()
                        .environmentObject(locationManager)
                }
                
                PlaceFilter(present: $showFilter)
                    .offset(y: showFilter ?  -UIScreen.main.bounds.size.height/4: -UIScreen.main.bounds.size.height)
                    .animation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 50, initialVelocity: 0), value: showFilter)
                    .environmentObject(placesVM)
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
                    .foregroundColor(.black)
                    .font(.custom("Inter-Black", size: 28))
                    .padding(), trailing: HStack( spacing: 20) {
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
                    }
        }.navigationViewStyle(StackNavigationViewStyle())
            .onChange(of: locationManager.status) { value in
                if value {
                    locationManager.startUpdating()
                }
            }
    }
}

struct Places_Previews: PreviewProvider {
    static var previews: some View {
        Places()
    }
}
