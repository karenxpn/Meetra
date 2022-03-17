//
//  Places.swift
//  Meetra
//
//  Created by Karen Mirakyan on 17.03.22.
//

import SwiftUI
import SwiftUIX

struct Places: View {
    var body: some View {
        
        NavigationView {
            VStack {
                
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
    }
}

struct Places_Previews: PreviewProvider {
    static var previews: some View {
        Places()
    }
}
