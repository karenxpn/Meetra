//
//  SwipeCards.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.04.22.
//

import SwiftUI

struct SwipeCards: View {
    @EnvironmentObject var placesVM: PlacesViewModel
    @Binding var switcher: Bool
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showFilter: Bool = false
    @State private var offsetOnDrag: CGFloat = 0
    
    var body: some View {
            
            ZStack( alignment: .top) {
                ForEach(placesVM.users) { user in
                    SingleSwipeUser(user: user)
                        .environmentObject(placesVM)
                }
                
                FilterUsers(present: $showFilter, gender: $placesVM.gender, status: $placesVM.status, range: $placesVM.ageRange)
                    .offset(y: showFilter ?  -UIScreen.main.bounds.size.height/4: -UIScreen.main.bounds.size.height)
                    .animation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 50, initialVelocity: 0), value: showFilter)
                    .offset(y: offsetOnDrag)
                    .gesture(DragGesture()
                        .onChanged({ (value) in
                            if value.translation.height < 0 {
                                self.offsetOnDrag = value.translation.height
                            }
                        }).onEnded({ (value) in
                            if value.translation.height < 0 {
                                self.showFilter = false
                                self.offsetOnDrag = 0
                            }
                        }))
            }.frame(minWidth: 0,
                    maxWidth: .infinity,minHeight: 0, maxHeight: .infinity)
            .onAppear {
                if(placesVM.users.count == 0) {
                    placesVM.swipePage = 0
                    placesVM.getSwipes()
                }
                AppAnalytics().logScreenEvent(viewName: "\(SwipeCards.self)")
            }.onChange(of: showFilter) { value in
                if !value {
                    placesVM.storeFilterValues(location: "place")
                }
            }.navigationBarTitle("", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: HStack {
                
                    Button {
                        self.presentationMode.wrappedValue.dismiss()
                    } label: {
                        VStack {
                            Image("content_view_back")
                                .foregroundColor(.black)
                        }
                    }
                
                Text("Meetra")
                    .kerning(0.56)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Black", size: 28))
                .padding(10)}, trailing: HStack( spacing: 20) {
                    Button {
                        showFilter.toggle()
                    } label: {
                        Image("icon_filter")
                            .foregroundColor(showFilter ? AppColors.accentColor : .black)
                    }
                    
                    NotificationButton()
                })
    }
}

struct SwipeCards_Previews: PreviewProvider {
    static var previews: some View {
        SwipeCards(switcher: .constant(false))
    }
}
