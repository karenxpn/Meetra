//
//  GlobalAuth.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import SwiftUI

struct GlobalAuth: View {
    @State private var showIntro: Bool = true
    var body: some View {
        
        if showIntro {
            Introduction(showIntro: $showIntro)
        } else {
            Authentication()
        }
    }
}

struct GlobalAuth_Previews: PreviewProvider {
    static var previews: some View {
        GlobalAuth()
    }
}
