//
//  BirthdayFields.swift
//  Meetra
//
//  Created by Karen Mirakyan on 03.03.22.
//

import SwiftUI

struct BirthdayFields: View {
    
    let placeholder: String
    let width: CGFloat
    @Binding var date: String
    
    var body: some View {
        TextField(placeholder, text: $date)
            .foregroundColor(.black)
            .font(.custom("Inter-SemiBold", size: 18))
            .multilineTextAlignment(.center)
            .padding(.vertical)
            .frame(width: width)
            .background(.white)
            .cornerRadius(10)
            .shadow(radius: 3, x: 0, y: 3)
    }
}
