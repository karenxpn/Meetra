//
//  SingleSwipeUser.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.03.22.
//

import SwiftUI
import SDWebImageSwiftUI
import TagLayoutView

struct SingleSwipeUser: View {
    
    @EnvironmentObject var placesVM: PlacesViewModel
    @State var user: SwipeUserViewModel
    @State private var goodSwipe: Bool = false
    
    let animation = Animation
        .interpolatingSpring(mass: 1.0,
                             stiffness: 50,
                             damping: 8,
                             initialVelocity: 0)
        .speed(0.8)
    
    var body: some View {
        
        ZStack ( alignment: .bottom, content: {
            
            VStack( spacing: 20) {
                
                ZStack( alignment: .leading) {
                    
                    WebImage(url: URL(string: user.image)!)
                        .placeholder {
                            ProgressView()
                        }.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                    VStack( alignment: .leading, spacing: 8) {
                        
                        HStack {
                            if user.online {
                                HStack {
                                    Circle()
                                        .fill(AppColors.onlineStatus)
                                        .frame(width: 6, height: 6)
                                    
                                    Text( NSLocalizedString("online", comment: ""))
                                        .foregroundColor(.white)
                                        .font(.custom("Inter-Regular", size: 8))
                                }.padding(.horizontal, 12)
                                    .padding(.vertical, 7)
                                    .background(.white.opacity(0.3))
                                    .cornerRadius(10)
                            }
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Image("dots")
                            }
                            
                        }
                        
                        Spacer()
                        
                        Text( "\(user.name), \(user.age)")
                            .foregroundColor(.white)
                            .font(.custom("Inter-SemiBold", size: 30))
                        
                        
                        HStack {
                            
                            TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 8)!,
                                           parentWidth: UIScreen.main.bounds.size.width * 0.5,
                                           interests: Array(user.interests.prefix(6)))
                            
                            Button {
                                
                            } label: {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.white)
                                    .font(.title)
                            }
                        }
                        
                    }.padding()
                    
                }.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.6)
                
                
                HStack( spacing: 15) {
                    
                    SwipeButtonHelper(icon: "left_arrow", width: 8, height: 14, horizontalPadding: 16, verticalPadding: 13) {
                        withAnimation(animation) {
                            user.x = -500; user.degree = -20
                        }
                    }
                    
                    SwipeButtonHelper(icon: "star.fill", width: 18, height: 18, horizontalPadding: 15, verticalPadding: 15) {
                        goodSwipe = true
                        // make request
                        withAnimation(animation) {
                            user.x = 500; user.degree = 20
                        }
                        print( "star" )
                    }
                    
                    SwipeButtonHelper(icon: "user_send_request", width: 18, height: 18, horizontalPadding: 15, verticalPadding: 15) {
                        goodSwipe = true
                        // make request
                        withAnimation(animation) {
                            user.x = 500; user.degree = 20
                        }
                        print( "send request" )
                    }
                    
                    SwipeButtonHelper(icon: "right_arrow", width: 8, height: 14, horizontalPadding: 16, verticalPadding: 13) {
                        withAnimation(animation) {
                            user.x = 500; user.degree = 20
                        }
                    }
                }
            }
        }).padding(16)
            .background(goodSwipe ? AppColors.onlineStatus : AppColors.addProfileImageBG)
            .cornerRadius(30)
            .shadow(radius: 3)
            .offset(x: user.x)
            .rotationEffect(.init(degrees: user.degree))
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        withAnimation(.default) {
                            user.x = value.translation.width
                            user.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                        }
                    })
                    .onEnded({ value in
                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                            switch value.translation.width {
                            case 0...100:
                                user.x = 0
                                user.degree = 0
                            case let x where x > 100:
                                if user.id == placesVM.users.first?.id {
                                    placesVM.swipePage += 1
                                    placesVM.getSwipes()
                                }
                                user.x = 500; user.degree = 20
                            case (-100)...(-1):
                                user.x = 0
                                user.degree = 0
                            case let x where x < -100:
                                if user.id == placesVM.users.first?.id {
                                    placesVM.swipePage += 1
                                    placesVM.getSwipes()
                                }
                                user.x = -500; user.degree = -20
                            default:
                                user.x = 0;
                            }
                        }
                    })
            )
    }
}

struct SingleSwipeUser_Previews: PreviewProvider {
    static var previews: some View {
        SingleSwipeUser(user: AppPreviewModels.swipeUserViewModel)
            .environmentObject(PlacesViewModel())
    }
}
