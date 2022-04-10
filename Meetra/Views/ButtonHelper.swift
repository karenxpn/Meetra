//
//  ButtonHelper.swift
//  Meetra
//
//  Created by Karen Mirakyan on 08.04.22.
//

import SwiftUI

struct ButtonHelper: View {
    
    var disabled: Bool
    let label: String
    let action: (() -> Void)

    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                
                Text( label )
                    .font(.custom("Inter-SemiBold", size: 20))
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                
                Spacer()
            }.background(AppColors.proceedButtonColor)
                .opacity(disabled ? 0.5 : 1)
                .cornerRadius(30)
        }.disabled(disabled)
    }
}
