//
//  TextFieldHelper.swift
//  Meetra
//
//  Created by Karen Mirakyan on 08.04.22.
//

import SwiftUI

struct TextFieldHelper: View {
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .foregroundColor(.black)
            .font(.custom("Inter-SemiBold", size: 18))
            .padding(.vertical, 15)
            .padding(.horizontal, 10)
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 3, x: 0, y: 3)
    }
}

struct TextFieldHelper_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldHelper(placeholder: "Ваше занятие", text: .constant(""))
    }
}
