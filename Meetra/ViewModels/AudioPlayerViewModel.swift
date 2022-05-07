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

class AudioPlayViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @AppStorage( "pending_files") private var localStorePendingFiles: Data = Data()
    
    @Published var player: AVAudioPlayer!
    @Published var session: AVAudioSession!
    private var timer: Timer?
    
    @Published var isPlaying: Bool = false
    @Published var duration: String = "0:0"
    
    @Published public var soundSamples = [AudioPreviewModel]()
    let sample_count: Int
    var index = 0
    let url: URL
    
    var dataManager: ChatServiceProtocol
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    init(url: URL, sampels_count: Int, dataManager: ChatServiceProtocol = ChatService.shared) {
        self.url = url
        self.sample_count = sampels_count
        self.dataManager = dataManager
        super.init()
        
        do {
            self.session = AVAudioSession.sharedInstance()
            
            try self.session.setCategory(.playAndRecord)
            try self.session.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            
        } catch {
            print(error.localizedDescription)
        }
        
        initializePlayer()
    }
    
    
    func getSignedURL(content_type: String, chatID: Int, completion: @escaping (GetSignedUrlResponse) -> ()) {
        dataManager.fetchSignedURL(key: Date().millisecondsSince1970, chatID: chatID,content_type: content_type)
            .sink { response in
                if response.error == nil {
                    DispatchQueue.main.async {
                        completion(response.value!)
                    }
                }
            }.store(in: &cancellableSet)
    }
    
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player.stop()
        self.timer?.invalidate()
        self.isPlaying = false
        self.index = 0
        self.soundSamples = self.soundSamples.map { tmp -> AudioPreviewModel in
            var cur = tmp
            cur.color = Color.gray
            return cur
        }
    }
    
    func startTimer() {
        let sample_count = (UIScreen.main.bounds.width * 0.5 / 6)
        let time_interval = player.duration / sample_count
        
        timer = Timer.scheduledTimer(withTimeInterval: time_interval, repeats: true, block: { (timer) in
            if self.index < self.soundSamples.count {
                withAnimation(Animation.linear) {
                    self.soundSamples[self.index].color = Color.black
                }
                self.index += 1
            }
        })
    }
    
    
    func playAudio() {
        if let player = player {
            player.play()
            startTimer()
            self.isPlaying = true
        }
    }
    
    func pauseAudio() {
        player.pause()
        timer?.invalidate()
        self.isPlaying = false
    }
    
    func initializePlayer() {
        if url.absoluteString.hasPrefix("https://") {
            do {
                let soundData = try Data(contentsOf: url)
                self.player = try AVAudioPlayer(data: soundData)
                guard player != nil else { return }
                
                self.player.delegate = self
                count_duration()
            } catch {
                print("error -> \(error.localizedDescription)")
            }
        } else {
            self.player = try? AVAudioPlayer(contentsOf: url)
            guard player != nil else { return }
            
            self.player.delegate = self
            count_duration()
        }
    }
    
    func count_duration() {
        let seconds = Int(self.player.duration.truncatingRemainder(dividingBy: 60))
        self.duration = "\(Int(self.player.duration / 60)):\(seconds < 10 ? "0\(seconds)" : "\(seconds)")"
    }
    
    func visualizeAudio() {
        dataManager.buffer(url: url, samplesCount: sample_count) { results in
            self.soundSamples.append(contentsOf: results)
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
