//
//  ProfileSpecs.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.04.22.
//

import SwiftUI

struct ProfileSpecs: View {
    
    let icon: String
    let label: String
    let value: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            HStack {
                Image(icon)
                Text( label )
                    .kerning(0.24)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                
                Spacer()
                
                Text( value.isEmpty ? "Указать" : value )
                    .kerning(0.24)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                
                Image("navigate_arrow")
                
            }.padding(.vertical, 5)
        }
    }
}

struct ProfileSpecs_Previews: PreviewProvider {
    static var previews: some View {
        ProfileSpecs(icon: "user_school_icon", label: "Образование", value: "Указать", destination: AnyView(Text( "Destination" )))
    }
}
