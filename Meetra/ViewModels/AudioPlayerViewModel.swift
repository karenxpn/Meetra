//
//  AudioPlayerViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 07.05.22.
//

import Foundation
import AVKit
import SwiftUI
import AVFoundation
import Combine

class AudioPlayViewModel: ObservableObject {
    
    private var timer: Timer?
    
    @Published var isPlaying: Bool = false
    @Published var duration: String = "0:0"
    
    @Published public var soundSamples = [AudioPreviewModel]()
    let sample_count: Int
    var index = 0
    let url: URL
    
    var dataManager: ChatServiceProtocol
    
    @Published var player: AVPlayer!
    @Published var session: AVAudioSession!
    
    init(url: URL, sampels_count: Int, dataManager: ChatServiceProtocol = ChatService.shared) {
        self.url = url
        self.sample_count = sampels_count
        self.dataManager = dataManager
        
        visualizeAudio()
        
        
        do {
            session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord)

            try session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            
        } catch {
            print(error.localizedDescription)
        }
        
        player = AVPlayer(url: self.url)
    }

    func startTimer() {
        let duration = count_duration()
        let time_interval = duration / Double(sample_count)
        
        timer = Timer.scheduledTimer(withTimeInterval: time_interval, repeats: true, block: { (timer) in
            if self.index < self.soundSamples.count {
                withAnimation(Animation.linear) {
                    self.soundSamples[self.index].color = Color.black
                }
                self.index += 1
            }
        })
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.player.pause()
        self.player.seek(to: .zero)
        self.timer?.invalidate()
        self.isPlaying = false
        self.index = 0
        self.soundSamples = self.soundSamples.map { tmp -> AudioPreviewModel in
            var cur = tmp
            cur.color = Color.gray
            return cur
        }
    }
    
    func playAudio() {
        
        if isPlaying {
            pauseAudio()
        } else {
            
            NotificationCenter.default.addObserver(self, selector:#selector(self.playerDidFinishPlaying(note:)),name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player.currentItem)

            isPlaying.toggle()
            player.play()
            
            startTimer()
            let duration = count_duration()
            
            let seconds = Int(duration.truncatingRemainder(dividingBy: 60))
            self.duration = "\(Int(duration / 60)):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")"
        }
    }
    
    func pauseAudio() {
        player.pause()
        timer?.invalidate()
        self.isPlaying = false
    }

    
    func count_duration() -> Float64 {
        if let duration = player.currentItem?.asset.duration {
            let seconds = CMTimeGetSeconds(duration)
            return seconds
        }
        
        return 1
    }
    
    func visualizeAudio() {
        dataManager.buffer(url: url, samplesCount: sample_count) { results in
            self.soundSamples = results
        }
    }
    
    func removeAudio() {
        do {
            try FileManager.default.removeItem(at: url)
            NotificationCenter.default.post(name: Notification.Name("hide_audio_preview"), object: nil)
            
        } catch {
            print(error)
        }
    }

}
