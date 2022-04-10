//
//  ProfileTopViewCompleteness.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.04.22.
//

import SwiftUI

struct ProfileTopViewCompleteness: View {
    let profile: ProfileModel
    var body: some View {
        VStack {
            ZStack( alignment: .topTrailing) {
                
                
                ZStack {
                    ImageHelper(image: profile.image, contentMode: .fill)
                        .frame(width: 140, height: 140)
                        .clipShape(Circle())
                    
                    ZStack( alignment: .bottom) {
                        Circle()
                            .stroke(lineWidth: 10)
                            .fill(AppColors.addProfileImageBG)
                            .frame(width: 160, height: 160)
                        
                        Circle()
                            .trim(from: 0, to: CGFloat(profile.filled) * 0.01 )
                            .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                            .fill(AppColors.accentColor)
                            .frame(width: 160, height: 160)
                            .rotationEffect(.degrees(90))
                        
                        Text( "\(profile.filled)% \(NSLocalizedString("filled", comment: ""))" )
                            .foregroundColor(.white)
                            .font(.custom("Inter-SemiBold", size: 14))
                            .padding(.vertical, 9)
                            .padding(.horizontal, 17)
                            .background(AppColors.proceedButtonColor)
                            .cornerRadius(30)
                            .offset(y: 15)
                        
                    }
                }
                
                NavigationLink(destination: EditProfile()) {
                    Image("edit_icon")
                        .padding(12)
                        .background(.white)
                        .cornerRadius(100)
                        .shadow(radius: 2)
                        .offset(x: 7, y: -7)
                }
            }
            
            HStack {
                Text( "\(profile.name), \(profile.age)" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 18))
                
                Image( profile.isVerified ? "verified_icon" : "not_verified_icon")
                
            }.padding(.top, 25)
            
        }
    }
}

struct ProfileTopViewCompleteness_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTopViewCompleteness(profile: AppPreviewModels.profile)
    }
}
