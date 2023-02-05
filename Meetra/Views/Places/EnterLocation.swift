//
//  EnterLocation.swift
//  Meetra
//
//  Created by Karen Mirakyan on 24.10.22.
//

import SwiftUI

struct EnterLocation: View {
    @Binding var alert: Bool
    
    var body: some View {
        VStack( spacing: 30 ){
            Spacer()
            
            Image("location_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 140)
            
            Text(NSLocalizedString("enterLocationRequest", comment: ""))
                .font(.custom("Inter-Regular", size: 16))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer()
            
            Button(action: {
                AppAnalytics().logEvent(event: "enter_location_request")
                alert.toggle()
            }) {
                
                HStack {
                    Spacer()
                    
                    Text( NSLocalizedString("enterLocation", comment: ""))
                        .font(.custom("Inter-SemiBold", size: 20))
                        .foregroundColor(.white)
                        .padding(.vertical, 15)
                    
                    Spacer()
                }.background(AppColors.proceedButtonColor)
                    .cornerRadius(30)
            }
            
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        ).padding(30)
            .padding(.bottom, UIScreen.main.bounds.size.height * 0.1)        
    }
}

struct EnterLocation_Previews: PreviewProvider {
    static var previews: some View {
        EnterLocation(alert: .constant(true))
    }
}
