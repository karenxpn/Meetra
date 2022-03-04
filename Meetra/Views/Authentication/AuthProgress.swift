//
//  AuthProgress.swift
//  Meetra
//
//  Created by Karen Mirakyan on 03.03.22.
//

import SwiftUI

struct AuthProgress: View {
    
    let page: Int
        
    var body: some View {
        GeometryReader { proxy in
            HStack( spacing: 0) {
                Spacer()
                ForEach( 0...6, id: \.self ) { index in
                    
                    if index == 0 || index == 6{
                        Rectangle()
                            .fill(index <= page ? AppColors.accentColor : AppColors.addProfileImageBG)
                            .cornerRadius(index == 0 ? [.topLeft, .bottomLeft] : [.topRight, .bottomRight], 20)
                    } else {
                        Rectangle()
                            .fill(index <= page ? AppColors.accentColor : AppColors.addProfileImageBG)
                    }
                }
                
                Spacer()
            }.frame( height: 6)
                .padding(.horizontal)
        }
    }
}

struct AuthProgress_Previews: PreviewProvider {
    static var previews: some View {
        AuthProgress(page: 6)
    }
}
