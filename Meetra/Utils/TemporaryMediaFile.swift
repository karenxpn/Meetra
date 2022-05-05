//
//  TemporaryMediaFile.swift
//  Meetra
//
//  Created by Karen Mirakyan on 04.05.22.
//

import Foundation
import Foundation
import AVKit
import SwiftUI

class TemporaryMediaFile {
    @AppStorage( "pending_files") private var localStorePendingFiles: Data = Data()

    var url: URL?
    var messageID: Int
    var type: String

    init(withData: Data, messageID: Int, type: String) {
        let directory = FileManager.default.temporaryDirectory
        let fileName = "\(NSUUID().uuidString).\(type == "video" ? "mov" : "jpg")"
        let url = directory.appendingPathComponent(fileName)
        
        self.messageID = messageID
        self.type = type
        
        do {
            try withData.write(to: url)
            self.url = url
                        
            // store url and message id locally
            if var pendingURLs = try? JSONDecoder().decode([PendingFileModel].self, from: localStorePendingFiles) {
                pendingURLs.append(PendingFileModel(url: url, messageID: messageID))
                
                if let newData = try? JSONEncoder().encode(pendingURLs) {
                    localStorePendingFiles = newData
                }
            }
//            let userDefaults = UserDefaults.standard
//            let pendingData = userDefaults.data(forKey: "pendingFiles")!
//            var pendingURLs = try! PropertyListDecoder().decode([PendingFileModel].self, from: pendingData)
//
//            userDefaults.set(pendingURLs, forKey: "pendingFiles")
        } catch {
            print("Error creating temporary file: \(error)")
        }
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

//    deinit {
//        self.deleteFile()
//    }
}
