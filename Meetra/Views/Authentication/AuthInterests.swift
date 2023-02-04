//
//  AuthInterestes.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.03.22.
//

import SwiftUI
import TagLayoutView

struct AuthInterests: View {
    @StateObject var authVM = AuthViewModel()
    @StateObject var locationManager = LocationManager()
    @State var model: RegistrationRequest
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: 30) {
                
                Text("Интересы:")
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 30))
                
                
                Text( "Выберите не менее 3 интересов" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 16))
                    .fixedSize(horizontal: false, vertical: true)
                
                if authVM.loading {
                    Loading()
                    
                } else {
                    GeometryReader { geometry in
                        
                        ScrollView {
                            TagLayoutView(
                                authVM.interests, tagFont: UIFont(name: "Inter-SemiBold", size: 12)!,
                                padding: 20,
                                parentWidth: geometry.size.width * 0.7) { tag in
                                    
                                    Button {
                                        
                                        if authVM.selected_interests.contains(where: {$0 == tag}) {
                                            authVM.selected_interests.removeAll(where: {$0 == tag})
                                        } else {
                                            authVM.selected_interests.append(tag)
                                        }
                                        
                                    } label: {
                                        Text(tag)
                                            .fixedSize()
                                            .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                                            .foregroundColor( authVM.selected_interests.contains(where: {$0 == tag}) ? .white : AppColors.accentColor)
                                            .background(RoundedRectangle(cornerRadius: 30)
                                                .strokeBorder(AppColors.accentColor, lineWidth: 1.5)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .fill(authVM.selected_interests.contains(where: {$0 == tag}) ?  AppColors.accentColor : .white)
                                                )
                                            )
                                        
                                    }
                                    
                                }.padding([.top, .trailing], 16)
                                .padding(.leading, 1)
                        }
                        
                    }.frame(width: UIScreen.main.bounds.size.width)
                }
                
                
                ButtonHelper(disabled: (authVM.selected_interests.count < 3 || authVM.loading),
                             label: NSLocalizedString("proceed", comment: "")) {
                    
                    model.interests = authVM.selected_interests
                    authVM.confirmSignUp(model: model)
                }.background(
                    NavigationLink(destination:AnyView(AuthNotificationPermission()),
                                    isActive: $authVM.navigate, label: {
                                       EmptyView()
                                   }).hidden()
                )
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            .padding(30)
            
            AuthProgress(page: 5)
        }.onAppear {
            authVM.getInterests()
            locationManager.initLocation()
        }.alert(isPresented: $authVM.showAlert) {
            Alert(title: Text( "Error" ), message: Text( authVM.alertMessage ), dismissButton: .default(Text( "OK" )))
        }
    }
}

struct AuthInterests_Previews: PreviewProvider {
    static var previews: some View {
        AuthInterests(model: RegistrationRequest())
    }
}
