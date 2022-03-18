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

    
    var body: some View {
        
        NavigationView {
            VStack {
                
                if locationManager.status {
                    
                    VStack {
                        Text( "OK\(seconds)" )

                    }.onReceive(timer) { _ in
                        seconds += 1
                        if seconds % 2 == 0 {
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
                
                
            }.navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading: Text("Meetra")
                                        .foregroundColor(.black)
                                        .font(.custom("Inter-Black", size: 28))
                                        .padding(), trailing: HStack( spacing: 20) {
                    Button {
                        
                    } label: {
                        Image("icon_filter")
                            .foregroundColor(.black)
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
