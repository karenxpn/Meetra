//
//  PlaceFilter.swift
//  Meetra
//
//  Created by Karen Mirakyan on 22.03.22.
//

import SwiftUI
import Sliders

struct FilterUsers: View {
    let genders = ["Мужчина", "Женщина", "Всех"]
    let statuses = ["Онлайн", "Всех"]
    
    @Binding var present: Bool
    @Binding var gender: String
    @Binding var status: String
    @Binding var range: ClosedRange<Int>
    
    var body: some View {
        VStack( alignment: .leading, spacing: 20) {
            
            Spacer()
            
            CustomSegmentPicker(selection: $gender, variants: genders, header: "Показывать анкеты:")
            
            AgeFilter(range: $range)
            
            CustomSegmentPicker(selection: $status, variants: statuses, header: "Показывать пользователей:")
            
            
            Button {
                present.toggle()
            } label: {
                HStack {
                    Spacer()
                    Image("filter-rectangle")
                    Spacer()
                }
            }.padding(.top, 30)
            
        }.padding(20)
            .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 450)
            .background(.white)
            .cornerRadius(35)
            .shadow(radius: 5, x: 0, y: 10)
    }
}
//
//struct PlaceFilter_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceFilter(present: .constant(false))
//            .environmentObject(PlacesViewModel())
//    }
//}
