//
//  MenuButtonsHelper.swift
//  Meetra
//
//  Created by Karen Mirakyan on 13.05.22.
//

import SwiftUI

struct MenuButtonsHelper: View {
    let label: String
    let role: ButtonRole
    let action: (() -> Void)

    var body: some View {
        
        Button {
            action()
        } label: {
            
            HStack {
                
                Text( label )
                    .kerning(0.36)
                    .foregroundColor(role == .destructive ? Color.red : Color.black)
                    .font(.custom("Inter-Regular", size: 12))
                                    
            }.frame(height: 37)
                .padding(.horizontal)
                .background(.white)
            
        }.buttonStyle(PlainButtonStyle())
    }
}
