//
//  EditInterests.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.04.22.
//

import SwiftUI
import TagLayoutView

struct EditInterests: View {
    
    @StateObject var profileVM = ProfileViewModel()
    @State var fields: ProfileEditFieldsViewModel
    
    @State private var selected_interests = [String]()
    
    var body: some View {
        
        EditProfileFieldBuilder(title: NSLocalizedString("interests", comment: ""),
                                showAlert: $profileVM.showAlert,
                                message: profileVM.alertMessage) {
            
            VStack(alignment: .leading) {
                
                Text( "Выберите не менее 3 интересов" )
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 16))
                    .fixedSize(horizontal: false, vertical: true)
                
                if profileVM.loading {
                    Loading()
                    
                } else {
                    
                    ScrollView {
                        TagLayoutView(
                            profileVM.interests, tagFont: UIFont(name: "Inter-SemiBold", size: 12)!,
                            padding: 20,
                            parentWidth: UIScreen.main.bounds.size.width * 0.8) { tag in
                                
                                Button {
                                    
                                    if selected_interests.contains(where: {$0 == tag}) {
                                        selected_interests.removeAll(where: {$0 == tag})
                                    } else {
                                        selected_interests.append(tag)
                                    }
                                    
                                } label: {
                                    Text(tag)
                                        .fixedSize()
                                        .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                                        .foregroundColor( selected_interests.contains(where: {$0 == tag}) ?  AppColors.accentColor : .white)
                                        .background(RoundedRectangle(cornerRadius: 30)
                                            .strokeBorder(AppColors.accentColor, lineWidth: 1.5)
                                            .background(
                                                RoundedRectangle(cornerRadius: 30)
                                                    .fill(selected_interests.contains(where: {$0 == tag}) ? .white : AppColors.accentColor)
                                            )
                                        )
                                    
                                }
                                
                            }.padding([.top, .trailing], 16)
                            .padding(.leading, 1)
                    }
                }
                
                ButtonHelper(disabled: (selected_interests.count < 3 ||
                                        selected_interests.containsSameElements(as: fields.interests)),
                             label: NSLocalizedString("save", comment: "")) {
                    
                    fields.interests = selected_interests
                    profileVM.updateProfile(fields: fields.fields)
                }
                
            }
        }.onAppear {
            selected_interests = fields.interests
            profileVM.getInterests()
        }
    }
}

struct EditInterests_Previews: PreviewProvider {
    static var previews: some View {
        EditInterests(fields: ProfileEditFieldsViewModel(fields: AppPreviewModels.fields))
    }
}
