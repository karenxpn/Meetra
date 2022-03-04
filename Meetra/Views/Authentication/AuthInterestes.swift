//
//  AuthInterestes.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.03.22.
//

import SwiftUI
import TagLayoutView

struct AuthInterestes: View {
    @ObservedObject var authVM = AuthViewModel()
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
                    ProgressView()
                } else {
                    GeometryReader { geometry in
                        
                        ScrollView {
                            TagLayoutView(
                                ["ulslazyxgq", "vaellgqhdd", "kzhvnmngzy", "zfhkfqbhwx", "yosgqcjqgw", "poygwoynpt", "brtxadpiay"], tagFont: UIFont(name: "Inter-SemiBold", size: 12)!,
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
                                        //                                            .font(.custom("Inter-SemiBold", size: 12))
                                            .fixedSize()
                                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                                            .foregroundColor( authVM.selected_interests.contains(where: {$0 == tag}) ?  AppColors.accentColor : .white)
                                            .background(RoundedRectangle(cornerRadius: 30)
                                                            .strokeBorder(AppColors.accentColor, lineWidth: 1.5)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 30)
                                                                    .fill(authVM.selected_interests.contains(where: {$0 == tag}) ? .white : AppColors.accentColor)
                                                            )
                                            )
                                        
                                    }
                                    
                                }.padding([.top, .trailing], 16)
                                .padding(.leading, 1)
                        }
                        
                    }.frame(width: UIScreen.main.bounds.size.width)
                }
                
                Spacer()
                
                
                Button {
                    model.interests = authVM.selected_interests
                } label: {
                    HStack {
                        Spacer()
                        
                        Text( "Продолжить" )
                            .font(.custom("Inter-SemiBold", size: 20))
                            .foregroundColor(.white)
                            .padding(.vertical, 15)
                        
                        Spacer()
                    }.background(AppColors.proceedButtonColor)
                        .opacity(authVM.selected_interests.count < 3 ? 0.5 : 1)
                        .cornerRadius(30)
                }.disabled(authVM.selected_interests.count < 3)
                //                    .background(
                //                        NavigationLink(destination: AuthInterestes(model: model), isActive: $navigate, label: {
                //                            EmptyView()
                //                        }).hidden()
                //                    )
                
            }.frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .topLeading
            )
                .padding(30)
            
            AuthProgress(page: 5)
        }.task(priority: .high) {
            authVM.getInterests()
        }.alert(isPresented: $authVM.showAlert) {
            Alert(title: Text( "Error" ), message: Text( authVM.alertMessage ), dismissButton: .default(Text( "OK" )))
        }
    }
}

struct AuthInterestes_Previews: PreviewProvider {
    static var previews: some View {
        AuthInterestes(model: RegistrationRequest())
    }
}
