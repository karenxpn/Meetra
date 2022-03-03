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
                    
                    if index == 0{
                        Rectangle()
                            .fill(AppColors.accentColor.opacity(index <= page ? 1 : 0.5))
                            .cornerRadius([.topLeft, .bottomLeft], 20)
                    } else if index == 6 {
                        Rectangle()
                            .fill(AppColors.accentColor.opacity(index <= page ? 1 : 0.5))
                            .cornerRadius([.topRight, .bottomRight], 20)
                    }else {
                        Rectangle()
                            .fill(AppColors.accentColor.opacity(index <= page ? 1 : 0.5))
                    }
                }
                
                Spacer()
            }.frame( height: 6)            
        }
    }
}

struct AuthProgress_Previews: PreviewProvider {
    static var previews: some View {
        AuthProgress(page: 6)
    }
}
