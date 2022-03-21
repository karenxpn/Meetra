//
//  Extensions.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import Foundation
import SwiftUI


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}


// Rounded Corner extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension String {
    
    var digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        return result
    }
    
    func extractDigits() -> Int {
        var tmp = ""
        let arr = Array( self )
        for i in arr {
            if i.isNumber {
                tmp += String( i )
            }
        }
        return Int( String( tmp ) )!
    }
}

extension Int {
    
    var numberString: String {
        
        guard self < 10 else { return "0" }
        
        return String(self)
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}


extension Image {
    init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
#if os(macOS)
        guard let image = NSImage(data: data) else { return nil }
        self.init(nsImage: image)
#elseif os(iOS)
        guard let image = UIImage(data: data) else { return nil }
        self.init(uiImage: image)
#else
        return nil
#endif
    }
}

extension Array {
    
    func custom_split() -> [[Element]] {
        var response = [[Element]]()
        var row = 0
        var index = 0
        
        while index < self.count {
            response.append([])
            if index % 3 == 0 || index + 1 >= self.count {
                response[row].append(self[index])
                index += 1
            } else if index + 1 < self.count {
                response[row].append(contentsOf: [self[index], self[index+1]])
                index += 2
            }
            row += 1
        }
        
        return response
    }
    
}
