//
//  ActionSheetButtonHelper.swift
//  Meetra
//
//  Created by Karen Mirakyan on 15.04.22.
//

import SwiftUI

struct ActionSheetButtonHelper: View {
    let icon: String
    let label: String
    let role: ButtonRole
    let action: (() -> Void)

    var body: some View {
        
        Button {
            action()
        } label: {
            
            HStack {
                
                Image(icon)

                Text( label )
                    .kerning(0.18)
                    .foregroundColor(role == .destructive ? Color.red : AppColors.starColor)
                    .font(.custom("Inter-Medium", size: 18))
                
                Spacer()
                    
            }.frame(height: 55)
                .padding(.horizontal)
                .background(.white)
            
        }
    }
}

struct ActionSheetButtonHelper_Previews: PreviewProvider {
    static var previews: some View {
        ActionSheetButtonHelper(icon: "", label: "Пожаловаться", role: .destructive, action: {
            
        })
    }
}
