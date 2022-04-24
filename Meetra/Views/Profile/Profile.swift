//
//  Profile.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.04.22.
//

import SwiftUI
import TagLayoutView

struct Profile: View {
    
    @StateObject var profileVM = ProfileViewModel()
    @State private var showFillPopup: Bool = true
    @State private var navigate_settings: Bool = false
    
    var body: some View {
        NavigationView {
            
            ProfileNavBar(settingsColor: .black,
                          title: NSLocalizedString("profile", comment: ""),
                          showAlert: $profileVM.showAlert,
                          message: profileVM.alertMessage, content: {
                
                ZStack {
                    
                    if profileVM.loading {
                        Loading()
                    } else if profileVM.profile != nil {
                        ScrollView( showsIndicators: false ) {
                            
                            VStack( spacing: 25 ) {
                                ProfileTopViewCompleteness(profile: profileVM.profile!)
                                
                                
                                if showFillPopup && !profileVM.profile!.isVerified {
                                    ZStack( alignment: .topTrailing) {
                                        Text( NSLocalizedString("fill_to_verify", comment: ""))
                                            .kerning(0.24)
                                            .foregroundColor(.black)
                                            .font(.custom("Inter-Regular", size: 12))
                                            .lineSpacing(2)
                                            .multilineTextAlignment(.center)
                                            .padding(.horizontal, 25)
                                            .padding(.vertical, 8)
                                        
                                        Button(action: {
                                            withAnimation {
                                                showFillPopup.toggle()
                                            }
                                        }, label: {
                                            Image("close_button")
                                        })
                                    }.padding(8)
                                        .background(AppColors.addProfileImageBG)
                                        .cornerRadius(10)
                                }
                                
                                VStack( alignment: .leading, spacing: 14) {
                                    Text( NSLocalizedString("about", comment: ""))
                                        .foregroundColor(.black)
                                        .font(.custom("Inter-SemiBold", size: 18))
                                    
                                    Text( profileVM.profile!.bio )
                                        .foregroundColor(.black)
                                        .font(.custom("Inter-Regular", size: 12))
                                    
                                }.padding(.horizontal, 30)
                                    .frame(minWidth: 0,
                                           maxWidth: .infinity,
                                           alignment: .leading)
                                
                                VStack( alignment: .leading) {
                                    Text( NSLocalizedString("interests", comment: ""))
                                        .foregroundColor(.black)
                                        .font(.custom("Inter-SemiBold", size: 18))
                                    
                                    TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 12)!,
                                                   parentWidth: UIScreen.main.bounds.size.width * 0.8,
                                                   interests: profileVM.profile!.interests.map{UserInterestModel(same: true, name: String($0))})
                                    
                                }.padding(.horizontal, 30)
                                    .frame(minWidth: 0,
                                           maxWidth: .infinity,
                                           alignment: .leading)
                                    .padding(.bottom, UIScreen.main.bounds.size.height * 0.1)
                                
                            }.padding(.top, 25)
                                .frame(minWidth: 0,
                                       maxWidth: .infinity,
                                       minHeight: 0,
                                       maxHeight: .infinity)
                            
                        }.padding(.top, 1)
                    }
                }
            }).onAppear {
                profileVM.getProfile()
            }
        }.navigationViewStyle(StackNavigationViewStyle())
            .gesture(DragGesture().onChanged({ _ in
                UIApplication.shared.endEditing()
            }))
    }
}


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
