//
//  Loading.swift
//  Meetra
//
//  Created by Karen Mirakyan on 22.03.22.
//

import SwiftUI
import ActivityIndicatorView

struct Loading: View {
    @State private var isRotated: Bool = false
    
    var animation: Animation {
        Animation.linear
            .repeatForever(autoreverses: false)
            .speed(0.5)
    }
    
    var body: some View {
        Circle()
            .trim(from: 0, to: 0.85)
            .stroke(lineWidth: 8)
            .fill(AppColors.accentColor)
            .frame(width: 70, height: 70)
            .rotationEffect(Angle.degrees(isRotated ? 360 : 0))
            .animation(animation, value: isRotated)
            .onAppear{
                DispatchQueue.main.async {
                    self.isRotated.toggle()
                }
                
            }.onDisappear{
                DispatchQueue.main.async {
                    self.isRotated.toggle()
                }
            }
    }
}

struct Loading_Previews: PreviewProvider {
    static var previews: some View {
        Loading()
    }
}
