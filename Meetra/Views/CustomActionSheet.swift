//
//  CustomActionSheet.swift
//  Meetra
//
//  Created by Karen Mirakyan on 15.04.22.
//

import SwiftUI

struct CustomActionSheet: View {
    @Environment(\.presentationMode) var presentationMode
    
    init() {
        UITableView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            
            BackgroundBlurView()
                .edgesIgnoringSafeArea(.all)
            
            Color.systemGray2.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                
                Spacer()
                
                VStack( spacing: 0) {
                
                    ForEach(1...4, id: \.self ) { item in
                        Text( NSLocalizedString("cancel", comment: "") )
                            .kerning(0.18)
                            .foregroundColor(AppColors.starColor)
                            .font(.custom("Inter-SemiBold", size: 18))
                            .frame(width: .greedy, height: 55)
                            .background(.white)
                        Divider()
                    }
                }.cornerRadius(17)
                    .padding(.horizontal)
                    .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 3)

                
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
                        .shadow(color: Color.gray.opacity(0.2), radius: 3, x: 0, y: 3)
                }.padding(.horizontal)
            }
        }.onTapGesture {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct CustomActionSheet_Previews: PreviewProvider {
    static var previews: some View {
        CustomActionSheet()
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
