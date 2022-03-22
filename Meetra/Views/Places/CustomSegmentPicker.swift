//
//  CustomSegmentPicker.swift
//  Meetra
//
//  Created by Karen Mirakyan on 22.03.22.
//

import SwiftUI

struct CustomSegmentPicker: View {
    
    @Binding var selection: String
    let variants: [String]
    let header: String
    var body: some View {
        
        VStack( alignment: .leading) {
            Text(header)
                .foregroundColor(.black)
                .font(.custom("Inter-SemiBold", size: 18))
            
            HStack {
                
                ForEach( variants, id: \.self ) { tmp in
                    
                    Button {
                        selection = tmp
                    } label: {
                        Text( tmp )
                            .foregroundColor(tmp == selection ? .white : .black)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 20)
                            .background(tmp == selection ? AppColors.accentColor : .clear)
                            .cornerRadius(30)
                        
                    }
                }
                
            }.padding(4)
            .background(AppColors.addProfileImageBG)
                .cornerRadius(30)
        }
    }
}

struct CustomSegmentPicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomSegmentPicker(selection: .constant("Мужчина"), variants: ["Man", "Women"], header: "Show Variants")
    }
}
