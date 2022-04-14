//
//  CustomActionSheet.swift
//  Meetra
//
//  Created by Karen Mirakyan on 15.04.22.
//

import SwiftUI

struct CustomActionSheet<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    private var content: Content

    
    init( @ViewBuilder content: () -> Content) {
        UITableView.appearance().backgroundColor = .clear
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            
            BackgroundBlurView()
                .edgesIgnoringSafeArea(.all)
            
            Color.systemGray2.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack( spacing: 15) {
                
                Spacer()
                
                VStack( alignment: .leading, spacing: 0) {
                    content
                }.cornerRadius(17)
                    .padding(.horizontal)
                    .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)

                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text( NSLocalizedString("cancel", comment: "") )
                        .kerning(0.18)
                        .foregroundColor(AppColors.starColor)
                        .font(.custom("Inter-SemiBold", size: 18))
                        .frame(width: .greedy, height: 55)
                        .background(.white)
                        .cornerRadius(17)
                        .shadow(color: Color.gray.opacity(0.4), radius: 5, x: 0, y: 5)
                }.padding(.horizontal)
                
            }.padding(.bottom)
        }.onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct BackgroundBlurView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.superview?.backgroundColor = .clear
        }
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
