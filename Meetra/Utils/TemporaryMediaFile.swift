//
//  TemporaryMediaFile.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.05.22.
//

import Foundation
import Foundation
import AVKit

class TemporaryMediaFile {
    var url: URL?

    init(withData: Data) {
        let directory = FileManager.default.temporaryDirectory
        let fileName = "\(NSUUID().uuidString).mov"
        let url = directory.appendingPathComponent(fileName)
        do {
            try withData.write(to: url)
            self.url = url
        } catch {
            print("Error creating temporary file: \(error)")
        }
    }

    public var avAsset: AVAsset? {
        if let url = self.url {
            return AVAsset(url: url)
        }

        return nil
    }

    public func deleteFile() {
        if let url = self.url {
            do {
                try FileManager.default.removeItem(at: url)
                self.url = nil
            } catch {
                print("Error deleting temporary file: \(error)")
            }
        }
    }

    deinit {
        self.deleteFile()
    }
}
