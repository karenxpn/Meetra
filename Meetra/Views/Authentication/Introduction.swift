//
//  Introduction.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import SwiftUI

struct Introduction: View {
    @State private var showAuth: Bool = false
    
    @State private var page: Int = 0
    let images = ["start_screen", "start_screen2", "start_screen3"]
    let texts = ["Посети классные места", "Найди собеседников по интересам", "Выбери компанию по душе"]
    
    var body: some View {
        ZStack {
            
            NavigationLink(destination: Authentication(), isActive: $showAuth) {
                EmptyView()
            }.hidden()
            
            Image(images[page])
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                HStack {
                    ForEach(0...2, id: \.self ) { index in
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white)
                            .frame(height: 6)
                            .opacity(index == page ? 1 : 0.5)
                    }
                }.padding(.horizontal)
                
                Spacer()
                
                Text("Meetra")
                    .foregroundColor(.white)
                    .font(.custom("Inter-Black", size: 74))
                    .padding(6)
                
                Text( texts[page] )
                    .foregroundColor(.white)
                    .font(.custom("Inter-Medium", size: 18))
                    .padding(.vertical, 6)
                    .padding(.horizontal, UIScreen.main.bounds.size.width * 0.15)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                
                Button {
                    showAuth.toggle()
                } label: {
                    Text("Начать")
                        .font(.custom("Inter-SemiBold", size: 22))
                        .foregroundColor(.white)
                        .frame(height: 56)
                        .padding(.horizontal, UIScreen.main.bounds.size.width * 0.25)
                        .background(AppColors.proceedButtonColor)
                        .cornerRadius(30)
                }.padding(.bottom, 50)
            }
            
            GetTapLocation { point in
                
                if point.y <= UIScreen.main.bounds.size.height * 0.5 {
                    if (UIScreen.main.bounds.size.width * 0.5...UIScreen.main.bounds.size.width).contains(point.x){
                        if page < 2 {
                            withAnimation {
                                page += 1
                            }
                        } else {
                            showAuth.toggle()
                        }
                    }
                }
            }.frame(height: UIScreen.main.bounds.size.height * 0.7)
            
            
            
        }.navigationBarHidden(true)
            .navigationBarTitle("")
    }
}

struct Introduction_Previews: PreviewProvider {
    static var previews: some View {
        Introduction()
    }
}
