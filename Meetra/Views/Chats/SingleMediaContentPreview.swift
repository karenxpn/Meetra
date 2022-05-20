//
//  SingleMediaContentPreview.swift
//  Meetra
//
//  Created by Karen Mirakyan on 20.05.22.
//

import SwiftUI
import AVFoundation

struct SingleMediaContentPreview: View {
    @Environment(\.presentationMode) var presentationMode
    let url: URL
    
    var body: some View {
        
        VStack {
            HStack {
                Spacer()
                
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("close_popup")
                        .padding()
                }

            }
            
            Spacer()
            
            if url.absoluteString.hasSuffix(".mov") {
                AVPlayerControllerRepresented(player: AVPlayer(url: url))
            } else {
                ImageHelper(image: url.absoluteString, contentMode: .fit)
            }
            
            Spacer()
        }

    }
}

struct SingleMediaContentPreview_Previews: PreviewProvider {
    static var previews: some View {
        SingleMediaContentPreview(url: URL(string: "https://meetraapp.s3.us-east-2.amazonaws.com/users/karen-1648577225513.jpg")!)
    }
}
