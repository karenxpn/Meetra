//
//  PlaceFilter.swift
//  Meetra
//
//  Created by Karen Mirakyan on 22.03.22.
//

import SwiftUI
import Sliders

struct PlaceFilter: View {
    let genders = ["Мужчина", "Женщина", "Всех"]
    let status = ["Онлайн", "Всех"]
    
    @EnvironmentObject var placeVM: PlacesViewModel
    @Binding var present: Bool
    
    var body: some View {
        VStack( alignment: .leading) {
            
            Spacer()
            
            CustomSegmentPicker(selection: $placeVM.gender, variants: genders, header: "Показывать анкеты:")
            

            AgeFilter().environmentObject(placeVM)
            
            CustomSegmentPicker(selection: $placeVM.status, variants: status, header: "Показывать пользователей:")

            
            
            
            Button {
                present.toggle()
            } label: {
                HStack {
                    Spacer()
                    Image("filter-rectangle")
                    Spacer()
                }
            }.padding(.top, 50)
            
        }.padding()
            .frame( minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: UIScreen.main.bounds.size.height * 0.6)
            .background(.white)
            .cornerRadius(35)
            .shadow(radius: 5)
    }
}

struct PlaceFilter_Previews: PreviewProvider {
    static var previews: some View {
        PlaceFilter(present: .constant(false))
            .environmentObject(PlacesViewModel())
    }
}
