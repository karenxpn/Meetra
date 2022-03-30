//
//  AgeFilter.swift
//  Meetra
//
//  Created by Karen Mirakyan on 22.03.22.
//

import SwiftUI
import Sliders

struct AgeFilter: View {
        
    @Binding var range: ClosedRange<Int>
    
    var body: some View {
        VStack( alignment: .leading, spacing: 10 ) {
            
            VStack( alignment: .leading, spacing: 0) {
                Text("Возраст:")
                    .foregroundColor(.black)
                    .font(.custom("Inter-SemiBold", size: 18))
                
                HStack {
                    Spacer()
                    Text("\(range.lowerBound) - \(range.upperBound)")
                        .foregroundColor(AppColors.filterGray)
                        .font(.custom("Inter-Regular", size: 12))
                }
            }
            
            
            RangeSlider(range: $range,
                        in: 18...51)
                .rangeSliderStyle(
                        HorizontalRangeSliderStyle(
                            track:
                                HorizontalRangeTrack(
                                    view: Capsule().foregroundColor(AppColors.accentColor)
                                )
                                .background(Capsule().foregroundColor(AppColors.accentColor.opacity(0.25)))
                                .frame(height: 3),
                            lowerThumb: Circle().foregroundColor(AppColors.accentColor),
                            upperThumb: Circle().foregroundColor(AppColors.accentColor),
                            lowerThumbSize: CGSize(width: 12, height: 12),
                            upperThumbSize: CGSize(width: 12, height: 12),
                            options: .forceAdjacentValue
                        )
                ).frame(height: 20)
            
            HStack {
                Text( "18" )
                    .foregroundColor(AppColors.filterGray)
                    .font(.custom("Inter-Regular", size: 12))
                Spacer()
                Text("50+")
                    .foregroundColor(AppColors.filterGray)
                    .font(.custom("Inter-Regular", size: 12))
            }
        }
    }
}

struct AgeFilter_Previews: PreviewProvider {
    static var previews: some View {
        AgeFilter(range: .constant(1...51))
    }
}
