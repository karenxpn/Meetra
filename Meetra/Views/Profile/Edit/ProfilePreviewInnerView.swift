//
//  ProfilePreviewInnerView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 08.04.22.
//

import SwiftUI

struct ProfilePreviewInnerView: View {
    let images: [String]
    @State var fields: ProfileEditFieldsViewModel
    
    var body: some View {
        ScrollView( showsIndicators: false ) {
            
            ImageCarousel(numberOfImages: images.count) {
                ForEach(images, id: \.self) { image in
                    
                    ImageHelper(image: image, contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width,
                               height: UIScreen.main.bounds.height * 0.55)
                        .clipped()
                }
            }
            
            VStack( alignment: .leading, spacing: 8) {
                
                HStack() {
                    
                    Text( "\(fields.name), \(fields.age)" )
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 30))
                    
                    if fields.isVerified {
                        Image("verified_icon")
                    }
                    
                    Circle()
                        .fill(AppColors.onlineStatus)
                        .frame(width: 10, height: 10)
                    
                    Spacer()
                    
                    
                    Image("star.fill")
                        .resizable()
                        .foregroundColor(AppColors.starColor)
                        .frame(width: 18, height: 18)
                        .padding()
                        .background(.white)
                        .cornerRadius(100)
                        .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 0, y: 3)

                    
                    Image("user_send_request")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding()
                        .background(.white)
                        .cornerRadius(100)
                        .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 0, y: 3)
                }
                
                HStack {
                    
                    if !fields.school.isEmpty {
                        Image("user_school_icon")
                        Text( fields.school )
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 12))
                    }
                    
                    if !fields.city.isEmpty {
                        Image("user_location_icon")
                        Text( fields.city )
                            .foregroundColor(.black)
                            .font(.custom("Inter-Regular", size: 12))
                    }
                }
                
                Text(NSLocalizedString("about", comment: ""))
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 18))
                    .padding(.top)
                
                Text( fields.bio)
                    .foregroundColor(.black)
                    .font(.custom("Inter-Regular", size: 12))
                    .fixedSize(horizontal: false, vertical: true)
                
                
                Text(NSLocalizedString("interests", comment: ""))
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 18))
                    .padding(.top)
                
                TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 12)!,
                               parentWidth: UIScreen.main.bounds.size.width * 0.75,
                               interests: fields.interests.map{ UserInterestModel(same: true, name: $0) })
                
                .padding([.top], 16)
            }
            .padding(25)
            .background(.white)
            .cornerRadius([.topLeft, .topRight], 34)
            .offset(y: -40)
        }.edgesIgnoringSafeArea(.top)
    }
}

struct ProfilePreviewInnerView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePreviewInnerView(images: [""], fields: ProfileEditFieldsViewModel(fields: AppPreviewModels.fields))
    }
}
