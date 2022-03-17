//
//  Places.swift
//  Meetra
//
//  Created by Karen Mirakyan on 17.03.22.
//

import SwiftUI
import SwiftUIX

struct Places: View {
    
    @ObservedObject var locationManager = LocationManager()
    @StateObject var placesVM = PlacesViewModel()
    
    init() {
        locationManager.initLocation()
    }
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                if locationManager.status {
                    Text( "OK" )
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
                })
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
