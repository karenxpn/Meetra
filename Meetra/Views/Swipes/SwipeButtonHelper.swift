//
//  SwipeButtonHelper.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.03.22.
//

import SwiftUI

struct SwipeButtonHelper: View {
    let icon: String
    let width: CGFloat
    let height: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let action: (() -> Void)
    
    var body: some View {
        
        Button(action: action) {
            Image( icon )
                .resizable()
                .foregroundColor(AppColors.starColor)
                .frame(width: width, height: height)
                .padding(.horizontal, horizontalPadding)
                .padding(.vertical, verticalPadding)
                .background(.white)
                .cornerRadius(100)
                .shadow(radius: 3, x: 0, y: 3)
        }
    }
}

struct SwipeButtonHelper_Previews: PreviewProvider {
    static var previews: some View {
        SwipeButtonHelper(icon: "star.fill", width: 18, height: 18, horizontalPadding: 15, verticalPadding: 15, action: {
            print("alskdjf")
        })
    }
}
