//
//  Profile.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.04.22.
//

import SwiftUI
import TagLayoutView

struct Profile: View {
    
    @ObservedObject var profileVM = ProfileViewModel()
    @State private var showFillPopup: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                
                if profileVM.loading {
                    Loading()
                } else if profileVM.profile != nil {
                    ScrollView( showsIndicators: false ) {
                        
                        VStack( spacing: 25 ) {
                            ProfileTopViewCompleteness(profile: profileVM.profile!)
                            
                            
                            if showFillPopup {
                                ZStack( alignment: .topTrailing) {
                                    Text( NSLocalizedString("fill_to_verify", comment: ""))
                                        .kerning(1)
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
                            
                            VStack( alignment: .leading) {
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
                                               interests: profileVM.profile!.interests.split(separator: ",")
                                    .map{UserInterestModel(same: true, name: String($0))})
                                
                            }.padding(.horizontal, 30)
                            .frame(minWidth: 0,
                                    maxWidth: .infinity,
                                    alignment: .leading)
                            
                        }.padding(.top, 25)
                            .frame(minWidth: 0,
                                   maxWidth: .infinity,
                                   minHeight: 0,
                                   maxHeight: .infinity)
                        
                    }.padding(.top, 1)
                }
                
                
            }.alert(isPresented: $profileVM.showAlert, content: {
                Alert(title: Text("Error"), message: Text(profileVM.alertMessage), dismissButton: .default(Text("Got it!")))
            })
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarItems(leading: Text(NSLocalizedString("profile", comment: ""))
                .foregroundColor(.black)
                .font(.custom("Inter-Black", size: 28))
                .padding(), trailing: HStack( spacing: 20) {
                    Button {
                        
                    } label: {
                        Image("settings_icon")
                    }
                    
                    Button {
                        
                    } label: {
                        Image("icon_ring")
                            .foregroundColor(.black)
                    }
                }).onAppear {
                    profileVM.getProfile()
                }
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
}


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile()
    }
}
