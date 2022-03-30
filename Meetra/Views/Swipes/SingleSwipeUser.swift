//
//  SingleSwipeUser.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.03.22.
//

import SwiftUI

struct SingleSwipeUser: View {
    
    @State var user: SwipeUserViewModel
    
    var body: some View {
        
        ZStack ( alignment: .center, content: {

            

        })
        .cornerRadius(15)
        .offset(x: user.x)
        .rotationEffect(.init(degrees: user.degree))
        .gesture(
            DragGesture()
                .onChanged({ value in
                    withAnimation(.default) {
                        if value.translation.width > 50 ||
                            value.translation.width < -50 {
                            user.x = value.translation.width
                            user.degree = 7 * (value.translation.width > 0 ? 1 : -1)
                        } else {
                            user.x = 0
                            user.degree = 0
                        }
                    }
                })
                .onEnded({ value in
                    withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 50, damping: 8, initialVelocity: 0)) {
                        switch value.translation.width {
                        case 0...100:
                            user.x = 0
                            user.degree = 0
                        case let x where x > 100:
//                            if match.id == matchesVM.matches.first?.id {
//                                matchesVM.matchPage += 1
//                                matchesVM.getMatches()
//                            }
                            user.x = 500; user.degree = 12
//                            matchesVM.sendFriendRequest(matchID: match.id)
                        case (-100)...(-1):
                            user.x = 0
                            user.degree = 0
                        case let x where x < -100:
//                            if match.id == matchesVM.matches.first?.id {
//                                matchesVM.matchPage += 1
//                                matchesVM.getMatches()
//                            }
                            user.x = -500; user.degree = -12
//                            matchesVM.removeMatch(matchID: match.id)
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
    }
}
