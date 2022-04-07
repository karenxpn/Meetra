//
//  ProfileEditingInnerView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.04.22.
//

import SwiftUI

struct ProfileEditingInnerView: View {
    @State var fields: ProfileEditFields
    let icons = ["user_occupation_icon", "user_school_icon", "user_gender_icon", "user_location_icon"]
    let names = ["Род деятельности", "Образование", "Пол", "Город"]
    
    var body: some View {
        ScrollView {
            VStack( alignment: .leading, spacing: 20) {
                Text( NSLocalizedString("about", comment: ""))
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 18))
                
                ZStack(alignment: .topLeading) {
                    
                    TextEditor(text: $fields.bio)
                        .foregroundColor(Color.black)
                        .font(.custom("Inter-Regular", size: 12))
                        .padding(.leading, 5)
                        .frame(height: 80)
                        .background(AppColors.addProfileImageBG)
                        .onAppear {
                            UITextView.appearance().backgroundColor = .clear
                        }.cornerRadius(10)
                    
                    if fields.bio.isEmpty {
                        Text("Расскажите вкратце о себе")
                            .kerning(0.24)
                            .font(.custom("Inter-Regular", size: 12))
                            .foregroundColor(Color.black)
                            .padding([.top, .leading], 10)
                    }
                }
                
                VStack( spacing: 5) {
                    ProfileSpecs(icon: icons[0], label: names[0], value: fields.occupation, destination: AnyView(Text( "Occupation" )))
                    ProfileSpecs(icon: icons[1], label: names[1], value: fields.school, destination: AnyView(Text( "School" )))
                    ProfileSpecs(icon: icons[2], label: names[2], value: fields.gender, destination: AnyView(Text( "Gender" )))
                    ProfileSpecs(icon: icons[3], label: names[3], value: fields.location, destination: AnyView(Text( "Location" )))
                }
                
                HStack {
                    Text( NSLocalizedString("interests", comment: ""))
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 18))
                    
                    Spacer()
                    
                    
                    NavigationLink {
                        EditInterests()
                    } label: {
                        Text( NSLocalizedString("change", comment: "") )
                            .foregroundColor(AppColors.proceedButtonColor)
                            .font(.custom("Inter-Regular", size: 12))
                    }
                }
                
                TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 12)!,
                               parentWidth: UIScreen.main.bounds.size.width * 0.8,
                               interests: fields.interests.map{ UserInterestModel(same: true, name: $0 )})
                
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .leading)
            .padding(.horizontal, 25)
        }
    }
}

struct ProfileEditingInnerView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditingInnerView(fields: AppPreviewModels.fields)
    }
}
