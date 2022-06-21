//
//  ProfileEditingInnerView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.04.22.
//

import SwiftUI

struct ProfileEditingInnerView: View {
    @EnvironmentObject var profileVM: ProfileViewModel
    @State var fields: ProfileEditFieldsViewModel
    @FocusState private var isFocused: Bool
    
    @State private var showPicker: Bool = false
    
    let icons = ["user_occupation_icon", "user_school_icon", "user_gender_icon", "user_location_icon"]
    let names = ["Род деятельности", "Образование", "Пол", "Город"]
    
    var body: some View {
        ScrollView( showsIndicators: false ) {
            VStack( alignment: .leading, spacing: 20) {
                
                HStack(spacing: 30) {
                    ForEach(0...1, id: \.self) { index in
                        EditProfileImageBox(images: $profileVM.profileImages, showPicker: $showPicker,
                                            height: UIScreen.main.bounds.size.height * 0.22,
                                            width:  UIScreen.main.bounds.size.width * 0.38,
                                            index: index, deleteAction: {
                            profileVM.deleteProfileImage(id: profileVM.profileImages[index].id)
                        })
                    }
                }.padding(.top)
                
                HStack(spacing: 30) {
                    ForEach(2...4, id: \.self) { index in
                        
                        EditProfileImageBox(images: $profileVM.profileImages, showPicker: $showPicker,
                                            height: UIScreen.main.bounds.size.height * 0.14,
                                            width:  UIScreen.main.bounds.size.width * 0.23,
                                            index: index) {
                            profileVM.deleteProfileImage(id: profileVM.profileImages[index].id)
                        }
                    }
                }
                
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
                        .focused($isFocused)
                        .onChange(of: isFocused) { isFocused in
                            if !isFocused {
                                profileVM.updateProfile(fields: fields.fields)
                            }
                        }
                    
                    if fields.bio.isEmpty {
                        Text("Расскажите вкратце о себе")
                            .kerning(0.24)
                            .font(.custom("Inter-Regular", size: 12))
                            .foregroundColor(Color.black)
                            .padding([.top, .leading], 10)
                    }
                }
                
                VStack( spacing: 5) {
                    ProfileSpecs(icon: icons[0], label: names[0], value: fields.job, destination: AnyView(EditOccupation(fields: fields)))
                    ProfileSpecs(icon: icons[1], label: names[1], value: fields.school, destination: AnyView(EditEducation(fields: fields)))
                    ProfileSpecs(icon: icons[2], label: names[2], value: fields.gender, destination: AnyView(EditGender(fields: fields)))
                    ProfileSpecs(icon: icons[3], label: names[3], value: fields.city, destination: AnyView(EditCity(fields: fields)))
                }
                
                HStack {
                    Text( NSLocalizedString("interests", comment: ""))
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 18))
                    
                    Spacer()
                    
                    
                    NavigationLink {
                        EditInterests(fields: fields)
                    } label: {
                        Text( NSLocalizedString("change", comment: "") )
                            .foregroundColor(AppColors.proceedButtonColor)
                            .font(.custom("Inter-Regular", size: 12))
                    }
                }
                
                TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 12)!,
                               parentWidth: UIScreen.main.bounds.size.width * 0.8,
                               interests: fields.interests.map{ UserInterestModel(same: true, name: $0 )})
                .padding(.bottom, UIScreen.main.bounds.size.height * 0.07)
                
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .leading)
            .padding(.horizontal, 25)
        }.sheet(isPresented: $showPicker) {
            Gallery(action: { images in
                //                profileVM.profileImages.append(contentsOf: images.map{ ProfileImageModel(id: UUID().hashValue,
                //                                                                                         type: "",
                //                                                                                         image: $0 )})
                
                let pref_five = profileVM.profileImages
                    .prefix(5)
                    .filter{ !$0.image.hasPrefix("https://")}
                    .map{ $0.image }
                
                profileVM.updateProfileImages(images: pref_five)
            }, existingImageCount: 0)
        }
    }
}

struct ProfileEditingInnerView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditingInnerView(fields: ProfileEditFieldsViewModel(fields: AppPreviewModels.fields))
            .environmentObject(ProfileViewModel())
    }
}
