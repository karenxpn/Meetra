//
//  EditProfileFieldBuilder.swift
//  Meetra
//
//  Created by Karen Mirakyan on 08.04.22.
//

import SwiftUI

struct EditProfileFieldBuilder<Content: View>: View {
    let title: String
    private var content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        content
            .frame(minWidth: 0,
                   maxWidth: .infinity,
                   minHeight: 0,
                   maxHeight: .infinity,
                   alignment: .leading)
            .padding(30)
            .padding(.bottom, UIScreen.main.bounds.size.height * 0.07)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Text(title)
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 28))
                .padding(.bottom, 10))
    }
}
