//
//  TagsViewHelper.swift
//  Meetra
//
//  Created by Karen Mirakyan on 30.03.22.
//

import SwiftUI
import TagLayoutView

struct TagsViewHelper: View {
    
    let font: UIFont
    let parentWidth: CGFloat
    let interests: [UserInterestModel]
    
    var body: some View {
        TagLayoutView(
            interests.map{$0.name}, tagFont: font,
            padding: 20,
            parentWidth: parentWidth) { tag in
                
                Text(tag)
                    .fixedSize()
                    .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 14))
                    .foregroundColor( interests.contains(where: {$0.name == tag && $0.same == true}) ?  .white : AppColors.accentColor)
                    .background(RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(AppColors.accentColor, lineWidth: 1.5)
                        .background(
                            RoundedRectangle(cornerRadius: 30)
                                .fill(interests.contains(where: {$0.name == tag && $0.same == true}) ? AppColors.accentColor : .white)
                        )
                    )
                
            }
    }
}

struct TagsViewHelper_Previews: PreviewProvider {
    static var previews: some View {
        TagsViewHelper(font: UIFont(name: "Inter-Regular", size: 8)!, parentWidth: UIScreen.main.bounds.width, interests: [UserInterestModel(same: true, name: "Coffee")])
    }
}
