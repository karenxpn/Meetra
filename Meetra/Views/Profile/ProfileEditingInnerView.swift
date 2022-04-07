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
    
    var body: some View {
        ScrollView {
            VStack( alignment: .leading, spacing: 20) {
                Text( NSLocalizedString("about", comment: ""))
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 18))
                
                ZStack(alignment: .leading) {
                    
                    TextEditor(text: $fields.bio)
                        .foregroundColor(Color.gray)
                        .font(.custom("Inter-Regular", size: 16))
                        .frame(height: 80)
                        .background(AppColors.addProfileImageBG)
                        .onAppear {
                            UITextView.appearance().backgroundColor = .clear
                        }.cornerRadius(10)
                    
                    if fields.bio.isEmpty {
                        
                        VStack {
                            Text("Расскажите вкратце о себе")
                                .kerning(0.24)
                                .font(.custom("Inter-Regular", size: 12))
                                .foregroundColor(Color.black)
                                .padding([.top, .leading], 10)
                            Spacer()
                        }.frame(height: 80)
                    }
                }
                
                VStack( spacing: 5) {
                    ForEach(fields.fields, id: \.id) { field in
                        ProfileSpecs(icon: icons[field.id], label: field.name, value: field.value)
                    }
                }
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
