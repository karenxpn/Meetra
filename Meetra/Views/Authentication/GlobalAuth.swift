//
//  GlobalAuth.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import SwiftUI

struct GlobalAuth: View {
    var body: some View {
        
        NavigationView {
            Introduction()
        }.navigationViewStyle(StackNavigationViewStyle())
            .gesture(DragGesture().onChanged({ _ in
                UIApplication.shared.endEditing()
            }))
    }
}

struct GlobalAuth_Previews: PreviewProvider {
    static var previews: some View {
        GlobalAuth()
    }
}
