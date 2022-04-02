//
//  UserInnerView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 27.03.22.
//

import SwiftUI
import SDWebImageSwiftUI
import TagLayoutView

struct UserInnerView: View {
    @EnvironmentObject var userVM: UserViewModel
    
    var body: some View {
        ScrollView( showsIndicators: false ) {
            
            ImageCarousel(numberOfImages: userVM.user!.images.count) {
                ForEach(userVM.user!.images, id: \.self) { image in
                    WebImage(url: URL(string: image))
                        .placeholder(content: {
                            ProgressView()
                        })
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.55)
                        .clipped()
                }
            }
            
            VStack( alignment: .leading, spacing: 8) {
                
                HStack() {
                    
                    Text( "\(userVM.user!.name), \(userVM.user!.age)" )
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 30))
                    
                    if userVM.user!.verified {
                        Image("verified_icon")
                    }
                    
                    if userVM.user!.online {
                        Circle()
                            .fill(AppColors.onlineStatus)
                            .frame(width: 10, height: 10)
                    }
                    
                    Spacer()
                    
                    Button {
                        userVM.starUser()
                    } label: {
                        Image( userVM.user!.starred ? "star.fill" : "star")
                            .resizable()
                            .foregroundColor(AppColors.starColor)
                            .frame(width: 18, height: 18)
                            .padding()
                            .background(.white)
                            .cornerRadius(100)
                            .shadow(radius: 3, x: 0, y: 3)
                    }
                    
                    Button(action: {
                        userVM.sendFriendRequest(userID: userVM.user!.id)
                    }, label: {
                        Image("user_send_request")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .padding()
                            .background(.white)
                            .cornerRadius(100)
                            .shadow(radius: 3, x: 0, y: 3)
                    })
                }
                
                HStack {
                    
                    if !userVM.user!.school.isEmpty {
                        Image("user_school_icon")
                        Text( userVM.user!.school )
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 12))
                    }
                    
                    if !userVM.user!.location.isEmpty {
                        Image("user_location_icon")
                        Text( userVM.user!.location )
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 12))
                    }
                }
                
                Text(NSLocalizedString("about", comment: ""))
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 18))
                    .padding(.top)
                
                Text( userVM.user!.bio)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                    .fixedSize(horizontal: false, vertical: true)
                
                
                Text(NSLocalizedString("interests", comment: ""))
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 18))
                    .padding(.top)
                
                TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 12)!,
                               parentWidth: UIScreen.main.bounds.size.width * 0.75,
                               interests: userVM.user!.interests)
                .padding([.top], 16)
            }
            .padding(25)
            .background(.white)
            .cornerRadius([.topLeft, .topRight], 34)
            .offset(y: -40)
        }.edgesIgnoringSafeArea(.top)
    }
}

struct UserInnerView_Previews: PreviewProvider {
    static var previews: some View {
        UserInnerView()
    }
}
