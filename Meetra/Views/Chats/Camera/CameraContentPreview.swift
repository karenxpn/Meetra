//
//  CameraContentPreview.swift
//  Meetra
//
//  Created by Karen Mirakyan on 09.05.22.
//

import Foundation
import SwiftUI
import AVKit
import UIKit

struct CameraContentPreview: View {
    let url: URL?
    
    var body: some View {
        
        
        ZStack {
            if url != nil {
                if checkURL() == "video" {
                    let player = AVPlayer(url: url!)
                    AVPlayerControllerRepresented(player: player)
                        .onAppear {
                            player.play()
                        }.onDisappear {
                            player.pause()
                        }
                } else {
                    
                    Image(uiImage: UIImage(contentsOfFile: url!.path)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                }
            }
        }.background(Color.black)
    }
    
    func checkURL() -> String {
        if url!.absoluteString.hasSuffix(".mov") {
            return "video"
        }
        return "photo"
    }
}
