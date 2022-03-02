//
//  OTPTextFieldView.swift
//  Meetra
//
//  Created by Karen Mirakyan on 02.03.22.
//

import SwiftUI
import SwiftUIX

struct OTPTextFieldView: View {
    
    var maxDigits: Int = 4
    
    @State var pin: String = ""
    
    var handler: (String) -> Void
    
    var body: some View {
        ZStack {
            pinDots
            backgroundField
        }
    }
    
    private var pinDots: some View {
        HStack(spacing:14) {
            ForEach(0..<maxDigits) { index in
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 47, height: 47)
                        .shadow(radius: 3, x: 0, y: 3)
                    
                    Text(self.getDigits(at: index))
                        .foregroundColor(.black)
                        .font(.custom("Inter-SemiBold", size: 18))
                }
            }
        }
    }
    
    private var backgroundField: some View {
        let boundPin = Binding<String>(get: { self.pin }, set: { newValue in
            self.pin = newValue
            self.submitPin()
        })
        
        return CocoaTextField("", text: boundPin, onCommit: submitPin)
            .keyboardType(.numberPad)
            .foregroundColor(.clear)
            .accentColor(.clear)
    }
    
    
    private func submitPin() {
        guard !pin.isEmpty else {
            return
        }
        
        if pin.count == maxDigits {
            
            handler(pin)
        }
        
        // this code is never reached under  normal circumstances. If the user pastes a text with count higher than the
        // max digits, we remove the additional characters and make a recursive call.
        if pin.count > maxDigits {
            pin = String(pin.prefix(maxDigits))
            submitPin()
        }
    }
    
    private func getDigits(at index: Int) -> String {
        if index >= self.pin.count {
            return ""
        }
        
        return self.pin.digits[index].numberString
    }
}


struct OTPTextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        OTPTextFieldView { otp in }
    }
}
