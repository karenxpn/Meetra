//
//  SingleSwipeUser.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.03.22.
//

import SwiftUI
import SDWebImageSwiftUI
import TagLayoutView
import SwiftUIX

enum CardAction {
    case swipe, report, star, request
}

struct SingleSwipeUser: View {
    
    @EnvironmentObject var placesVM: PlacesViewModel
    @ObservedObject var userVM = UserViewModel()
    @State var user: SwipeUserViewModel
    @State private var navigate: Bool = false
    @State private var showDialog: Bool = false
    @State private var showReportConfirmation: Bool = false
    
    @State private var cardAction: CardAction? = .none
    
    let animation = Animation
        .interpolatingSpring(mass: 1.0,
                             stiffness: 50,
                             damping: 8,
                             initialVelocity: 0)
        .speed(0.5)
    
    var body: some View {
        
        VStack( spacing: 20) {
            
            ZStack( alignment: .leading) {
                
                ImageHelper(image: user.image, contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width * 0.8,
                           height: UIScreen.main.bounds.height * 0.55)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                
                VStack( alignment: .leading, spacing: 8) {
                    
                    HStack( alignment: .top) {
                        
                        VStack( alignment: .leading) {
                            
                            
                            if user.verified {
                                HStack {
                                    Image("verified_icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 12, height: 12)
                                    
                                    Text( NSLocalizedString("verified", comment: ""))
                                        .foregroundColor(.white)
                                        .font(.custom("Inter-Regular", size: 8))
                                }.padding(.horizontal, 9)
                                    .frame(height: 21)
                                    .background(.white.opacity(0.3))
                                    .cornerRadius(20)
                            }
                            
                            
                            if user.online {
                                HStack {
                                    Circle()
                                        .fill(AppColors.onlineStatus)
                                        .frame(width: 6, height: 6)
                                    
                                    Text( NSLocalizedString("online", comment: ""))
                                        .foregroundColor(.white)
                                        .font(.custom("Inter-Regular", size: 8))
                                }.padding(.horizontal, 9)
                                    .frame(height: 21)
                                    .background(.white.opacity(0.3))
                                    .cornerRadius(20)
                            }
                            
                        }
                        
                        Spacer()
                        
                        Button {
                            showDialog.toggle()
                        } label: {
                            Image("dots")
                                .foregroundColor(.white)
                        }.fullScreenCover(isPresented: $showDialog) {
                            CustomActionSheet {
                                
                                ActionSheetButtonHelper(icon: "report_icon",
                                                        label: NSLocalizedString("report", comment: ""),
                                                        role: .destructive) {
                                    self.showReportConfirmation.toggle()
                                }.alert(NSLocalizedString("chooseReason", comment: ""), isPresented: $showReportConfirmation, actions: {
                                    Button {
                                        userVM.reportReason = NSLocalizedString("fraud", comment: "")
                                        reportUser()

                                    } label: {
                                        Text( NSLocalizedString("fraud", comment: "") )
                                    }
                                    
                                    Button {
                                        userVM.reportReason = NSLocalizedString("insults", comment: "")
                                        reportUser()
                                    } label: {
                                        Text( NSLocalizedString("insults", comment: "") )
                                    }
                                    
                                    Button {
                                        userVM.reportReason = NSLocalizedString("fakeAccount", comment: "")
                                        reportUser()
                                    } label: {
                                        Text( NSLocalizedString("fakeAccount", comment: "") )
                                    }
                                    
                                    Button(NSLocalizedString("cancel", comment: ""), role: .cancel) { }

                                })
                                
                                Divider()
                                
                                ActionSheetButtonHelper(icon: "block_icon",
                                                        label: NSLocalizedString("block", comment: ""),
                                                        role: .destructive) {
                                    self.showDialog.toggle()
                                    cardAction = .report
                                    withAnimation(animation) {
                                        user.x = -1000; user.degree = -20
                                        checkLastAndRequestMore()
                                    }
                                    
                                    userVM.blockUser(id: user.id)
                                }
                            }
                        }                        
                    }
                    
                    Spacer()
                    
                    Text( "\(user.name), \(user.age)")
                        .foregroundColor(.white)
                        .font(.custom("Inter-SemiBold", size: 30))
                    
                    
                    HStack {
                        
                        TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 12)!,
                                       parentWidth: UIScreen.main.bounds.size.width * 0.55,
                                       interests: user.interests.count <= 4 ?
                                       user.interests : Array(user.interests.prefix(3)) +
                                       [UserInterestModel(same: false, name: "+ \(NSLocalizedString("more", comment: "")) \(user.interests.count - 3)")])
                        
                        Button {
                            navigate.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.white)
                                .font(.title)
                        }.background(
                            NavigationLink(destination: UserView(userID: user.id), isActive: $navigate, label: {
                                EmptyView()
                            }).hidden()
                        )
                    }
                    
                }.padding()
                
            }.frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.55)
            
            
            HStack( spacing: 15) {
                
                SwipeButtonHelper(icon: "left_arrow", width: 8, height: 14, horizontalPadding: 16, verticalPadding: 13) {
                    AppAnalytics().logEvent(event: "swipe")
                    cardAction = .swipe
                    withAnimation(animation) {
                        user.x = -1000; user.degree = -20
                        checkLastAndRequestMore()
                    }
                }
                
                SwipeButtonHelper(icon: "star.fill", width: 18, height: 18, horizontalPadding: 15, verticalPadding: 15) {
                    AppAnalytics().logEvent(event: "swipe_star")

                    cardAction = .star
                    userVM.starUserFromSwipes(userID: user.id)
                    // make request
                    withAnimation(animation) {
                        user.x = 1000; user.degree = 20
                        checkLastAndRequestMore()
                    }
                }
                
                SwipeButtonHelper(icon: "user_send_request", width: 18, height: 18, horizontalPadding: 15, verticalPadding: 15) {
                    AppAnalytics().logEvent(event: "swipe_friend_request")

                    cardAction = .request
                    userVM.sendFriendRequest(userID: user.id)
                    // make request
                    withAnimation(animation) {
                        user.x = 1000; user.degree = 20
                        checkLastAndRequestMore()
                    }
                }
                
                SwipeButtonHelper(icon: "right_arrow", width: 8, height: 14, horizontalPadding: 16, verticalPadding: 13) {
                    AppAnalytics().logEvent(event: "swipe")

                    cardAction = .swipe
                    withAnimation(animation) {
                        user.x = 1000; user.degree = 20
                        checkLastAndRequestMore()
                    }
                }
            }
        }.padding(16)
            .background(
                Group {
                    switch cardAction {
                    case .request:
                        AppColors.onlineStatus
                    case .report:
                        AppColors.reportColor
                    case .star:
                        AppColors.starColor
                    case .swipe:
                        AppColors.proceedButtonColor
                    default:
                        AppColors.addProfileImageBG
                    }
                }
            )
            .cornerRadius(30)
            .shadow(radius: 1)
            .offset(x: user.x)
            .rotationEffect(.init(degrees: user.degree))
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        self.cardAction = .swipe
                        withAnimation(.default) {
                            user.x = value.translation.width
                            user.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                        }
                    })
                    .onEnded({ value in
                        withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                            switch value.translation.width {
                            case 0...100:
                                self.cardAction = .none
                                user.x = 0
                                user.degree = 0
                            case let x where x > 100:
                                checkLastAndRequestMore()
                                user.x = 1000; user.degree = 20
                                AppAnalytics().logEvent(event: "swipe")
                            case (-100)...(-1):
                                self.cardAction = .none
                                user.x = 0
                                user.degree = 0
                            case let x where x < -100:
                                checkLastAndRequestMore()
                                user.x = -1000; user.degree = -20
                                AppAnalytics().logEvent(event: "swipe")
                            default:
                                self.cardAction = .none
                                user.x = 0;
                                user.degree = 0
                            }
                        }
                    })
            )
    }
    
    func checkLastAndRequestMore() {
        if user.id == placesVM.users.first?.id {
            placesVM.swipePage += 1
            placesVM.getSwipes()
        }
    }
    
    func reportUser() {
        cardAction = .report
        withAnimation(animation) {
            user.x = -1000; user.degree = -20
            checkLastAndRequestMore()
        }
        
        userVM.reportUser(id: user.id)
        self.showDialog.toggle()
    }
}

struct SingleSwipeUser_Previews: PreviewProvider {
    static var previews: some View {
        SingleSwipeUser(user: AppPreviewModels.swipeUserViewModel)
            .environmentObject(PlacesViewModel())
    }
}
