//
//  ImageCarousel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 31.03.22.
//

import SwiftUI
import SDWebImageSwiftUI
import Combine

struct ImageCarousel<Content: View>: View {
    private var numberOfImages: Int
    private var content: Content
    
    @State private var dragResult: CGFloat = 0
    @State private var currentIndex: Int = 0
    
    init(numberOfImages: Int, @ViewBuilder content: () -> Content) {
        self.numberOfImages = numberOfImages
        self.content = content()
    }
    
    var body: some View {
        // 1
        ZStack(alignment: .bottom) {
            HStack( alignment: .center, spacing: 0) {
                self.content
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.55, alignment: .leading)
            .offset(x: CGFloat(self.currentIndex) * -UIScreen.main.bounds.width, y: 0)
            .animation(.spring(), value: currentIndex)
            .gesture(DragGesture()
                .onChanged({ (gesture) in
                    self.dragResult = gesture.translation.width
                })
                    .onEnded({ _ in
                        if self.dragResult < 0 {
                            
                            self.currentIndex = ( self.currentIndex + 1 ) % self.numberOfImages
                        } else {
                            if self.numberOfImages == 1 {
                                self.currentIndex = 0
                            } else {
                                self.currentIndex = self.currentIndex == 0 ? self.numberOfImages - abs( self.currentIndex - 1 ) % self.numberOfImages : abs( self.currentIndex - 1 ) % self.numberOfImages
                            }
                            
                        }
                    })
                     
            )
            
            
            HStack(spacing: 3) {
                ForEach(0..<self.numberOfImages, id: \.self) { index in
                    
                    if index == currentIndex {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppColors.proceedButtonColor.opacity(0.8))
                            .frame(width: 20, height: 10)
                            
                    } else {
                        Circle()
                            .frame(width: 10,
                                   height: 10)
                            .foregroundColor(Color.white.opacity(0.3))
                            .animation(.spring(), value: currentIndex)
                    }
                    
                }
            }
            .offset(y: -50)

        }
    }
}
