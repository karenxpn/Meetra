//
//  Chats.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import SwiftUI

struct Chats: View {
    @State private var showSearchField: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                
                VStack(alignment: .leading, spacing: 20) {
                    Text( NSLocalizedString("interlocutors", comment: ""))
                        .kerning(0.18)
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 18))
                        .padding(.leading, 26)
                    
                    Interlocutors()

                }.listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())

                
                Text( "Here should be chats" )
                    .listRowSeparator(.hidden)
                    .frame(width: .greedy)
                    .background(.red)
                    .listRowInsets(EdgeInsets())
                
            }.listStyle(.plain)
                .padding(.top, 1)
            .navigationBarTitle("", displayMode: .inline)
                .navigationBarItems(leading: Text(NSLocalizedString("chats", comment: ""))
                    .kerning(0.56)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Black", size: 28))
                    .padding(10), trailing: HStack( spacing: 20) {
                        Button {
                            showSearchField.toggle()
                        } label: {
                            Image("icon_search")
                                .foregroundColor(showSearchField ? AppColors.accentColor : .black)
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

struct Chats_Previews: PreviewProvider {
    static var previews: some View {
        Chats()
    }
}
