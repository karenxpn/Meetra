//
//  CountryCodeSelection.swift
//  Meetra
//
//  Created by Karen Mirakyan on 02.03.22.
//

import SwiftUI


import SwiftUI

struct CountryCodeSelection: View {
    
    @Binding var isPresented: Bool
    @Binding var country: String
    @Binding var code: String
    
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView( showsIndicators: false) {
                    LazyVStack( alignment: .leading) {
                        ForEach( Array( Credentials.countryCodeList.keys ).sorted(), id: \.self )  { key in
                            
                            Button {
                                code = Credentials.countryCodeList[key]!
                                country = key
                                isPresented.toggle()
                            } label: {
                                HStack {
                                    Text( countryName(countryCode: key) ?? "Undefined" )
                                        .font(.custom("Inter-Regular", size: 20))
                                        .foregroundColor(.black)
                                    
                                    Text( Credentials.countryCodeList[key]!)
                                        .font(.custom("Inter-Regular", size: 20))
                                            .foregroundColor(.black)
                                    
                                    Spacer()
                                }.padding(.horizontal)
                                .padding( .vertical, 8)
                            }
                            
                            Divider()
                        }
                    }
                }.padding( .top, 1 )
            }.navigationBarTitle( Text( "Телефонный код" ), displayMode: .inline)
            .navigationBarItems(trailing: Button {
                self.isPresented.toggle()
            } label: {
                Text( "Cancel" )
            })
        }
    }
    
    func countryName(countryCode: String) -> String? {
            let current = Locale(identifier: "ru_RU")
            return current.localizedString(forRegionCode: countryCode)
        }
}

struct CountryCodeSelection_Previews: PreviewProvider {
    static var previews: some View {
        CountryCodeSelection(isPresented: .constant( false ), country: .constant( "" ), code: .constant(""))
    }
}
