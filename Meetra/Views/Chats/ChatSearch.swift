//
//  ChatSearch.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import SwiftUI

struct ChatSearch: View {
    @EnvironmentObject var chatVM: ChatViewModel
    
    var body: some View {
        HStack( spacing: 10) {
            Spacer()
            Image("icon_search")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 14, height: 14)
                .foregroundColor(.gray)
            
            TextField(NSLocalizedString("searchBy", comment: ""), text: $chatVM.search)
                .foregroundColor(.gray)
                .font(.custom("Inter-Regular", size: 14))
        }.frame(width: UIScreen.main.bounds.width * 0.6, height: 40, alignment: .center)
            .padding(.horizontal)
        .background(AppColors.addProfileImageBG)
        .cornerRadius(20)
    }
}

struct ChatSearch_Previews: PreviewProvider {
    static var previews: some View {
        ChatSearch()
            .environmentObject(ChatViewModel())
    }
}
