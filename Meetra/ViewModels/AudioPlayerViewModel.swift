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

class AudioPlayViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var player: AVAudioPlayer!
    @Published var session: AVAudioSession!
    private var timer: Timer?
    
    @Published var isPlaying: Bool = false
    @Published var duration: String = "0:0"
    
    @Published public var soundSamples = [AudioPreviewModel]()
    let sample_count = Int(UIScreen.main.bounds.width * 0.5 / 6)
    var index = 0
    let url: URL

    
    init(url: URL) {
        self.url = url
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
    
    func startAudio() {
        

        //        guard let fileURL = URL(string: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3") else { return  }
        //            do {
        //                let soundData = try Data(contentsOf: fileURL)
        //                self.player = try? AVAudioPlayer(data: soundData)
        //                print(soundData)
        //                guard player != nil else { return }
        //
        //                self.player.delegate = self
        //                startMonitoring(samples: samples)
        //
        //            } catch {
        //                print(error)
        //            }
        
        
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
        self.player = try? AVAudioPlayer(contentsOf: url)
        guard player != nil else { return }
        
        self.player.delegate = self
    }
    
    func visualizeAudio() {
        buffer(url: url, samplesCount: sample_count) { results in
            self.soundSamples.append(contentsOf: results)
        }
    }
    
    func removeAudio() {
        do {
            try FileManager.default.removeItem(at: url)
            NotificationCenter.default.post(name: Notification.Name("audio_preview_removed"), object: nil)

        } catch {
            print(error)
        }
    }
    
    func buffer(url: URL, samplesCount: Int, completion: @escaping([AudioPreviewModel]) -> ()) {
        do {
            let file = try AVAudioFile(forReading: url)
            if let format = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                          sampleRate: file.fileFormat.sampleRate,
                                          channels: file.fileFormat.channelCount, interleaved: false),
               let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(file.length)) {
                
                try file.read(into: buf)
                guard let floatChannelData = buf.floatChannelData else { return }
                let frameLength = Int(buf.frameLength)
                
                let samples = Array(UnsafeBufferPointer(start:floatChannelData[0], count:frameLength))
                //        let samples2 = Array(UnsafeBufferPointer(start:floatChannelData[1], count:frameLength))
                
                var result = [AudioPreviewModel]()
                
                let chunked = samples.chunked(into: samples.count / samplesCount)
                for row in chunked {
                    var accumulator: Float = 0
                    let newRow = row.map{ $0 * $0 }
                    accumulator = newRow.reduce(0, +)
                    let power: Float = accumulator / Float(row.count)
                    let decibles = 10 * log10f(power)
                    
                    result.append(AudioPreviewModel(magnitude: decibles, color: Color.gray))
                }
                                
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        } catch {
            print("Audio Error: \(error)")
        }
    }
}
