//
//  ChatService.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import Foundation
import Combine
import Alamofire
import SwiftUI
import AVFoundation

protocol ChatServiceProtocol {
    func fetchChatList(page: Int, query: String) -> AnyPublisher<DataResponse<ChatListModel, NetworkError>, Never>
    func fetchInterlocutors() -> AnyPublisher<DataResponse<InterlocutorsListModel, NetworkError>, Never>
    
    func changeChatNotificationStatus(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func deleteChat(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func markUnread(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    func leaveChat(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never>
    
    func fetchChatId(userId: Int) -> AnyPublisher<DataResponse<GetChatIdResponse, NetworkError>, Never>
    func fetchNewConversationResponse(roomID: Int) -> AnyPublisher<DataResponse<NewConversationResponse, NetworkError>, Never>
    
    func fetchChatMessages(roomID: Int, messageID: Int) -> AnyPublisher<DataResponse<MessagesListModel, NetworkError>, Never>
    func fetchSignedURL(key: Int64, chatID: Int, content_type: String, repliedTo: Int?, duration: String?) -> AnyPublisher<DataResponse<GetMessageSignedUrlResponse, NetworkError>, Never>
    
    func storeLocalFile(withData: Data, messageID: Int, type: String, completion: @escaping([PendingFileModel]) -> ())
    func storeFileToServer(file: Data, url: String, completion: @escaping(Bool) -> ())
    func removeLocalFile(url: URL, messageID: Int, completion: @escaping() -> ())
    
    func buffer(url: URL, samplesCount: Int, completion: @escaping([AudioPreviewModel]) -> ())
}

class ChatService {
    static let shared: ChatServiceProtocol = ChatService()
    private init() { }
}

extension ChatService: ChatServiceProtocol {
    func leaveChat(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)chats/leave")!
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["chatId" : id], url: url, method: .patch, responseType: GlobalResponse.self)
    }
    
    func markUnread(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)chats/mark-as-unread")!
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["chatId" : id], url: url, method: .patch, responseType: GlobalResponse.self)
    }
    
    func deleteChat(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)chats/\(id)")!
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, method: .delete, responseType: GlobalResponse.self)
    }
    
    func changeChatNotificationStatus(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)chats/mute")!
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["chatId" : id], url: url, method: .patch, responseType: GlobalResponse.self)
    }
    
    func buffer(url: URL, samplesCount: Int, completion: @escaping([AudioPreviewModel]) -> ()) {
        
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                var cur_url = url
                if url.absoluteString.hasPrefix("https://") {
                    let data = try Data(contentsOf: url)
                    
                    let directory = FileManager.default.temporaryDirectory
                    let fileName = "chunk.m4a)"
                    cur_url = directory.appendingPathComponent(fileName)
                    
                    try data.write(to: cur_url)
                }
                
                let file = try AVAudioFile(forReading: cur_url)
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
    
    func fetchNewConversationResponse(roomID: Int) -> AnyPublisher<DataResponse<NewConversationResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)chats/\(roomID)/new-conversation")!
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: NewConversationResponse.self)
    }
    
    func removeLocalFile(url: URL, messageID: Int, completion: @escaping () -> ()) {
        @AppStorage( "pending_files") var localStorePendingFiles: Data = Data()
        
        do {
            try FileManager.default.removeItem(at: url)
            var pendingURLs: [PendingFileModel] = {
                do {
                    return try JSONDecoder().decode([PendingFileModel].self, from: localStorePendingFiles)
                } catch {
                    return []
                }
            }()
            
            pendingURLs.removeAll(where: {$0.messageID == messageID})
            
            if let newData = try? JSONEncoder().encode(pendingURLs) {
                localStorePendingFiles = newData
                
                DispatchQueue.main.async {
                    completion()
                }
            }
            
        } catch {
            print("Error creating temporary file: \(error)")
        }
    }
    
    func storeFileToServer(file: Data, url: String, completion: @escaping(Bool) -> ()) {
        AF.upload(file, to: url, method: .put).response { response in
            if response.error != nil {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            DispatchQueue.main.async {
                completion(true)
            }
        }
    }
    
    
    func storeLocalFile(withData: Data, messageID: Int, type: String, completion: @escaping([PendingFileModel]) -> ()) {
        @AppStorage( "pending_files") var localStorePendingFiles: Data = Data()
        
        let directory = FileManager.default.temporaryDirectory
        let fileName = "\(NSUUID().uuidString).\(type == "video" ? "mov" : type == "audio" ? "m4a" : "jpg")"
        let url = directory.appendingPathComponent(fileName)
        
        do {
            try withData.write(to: url)
            var pendingURLs: [PendingFileModel] = {
                do {
                    return try JSONDecoder().decode([PendingFileModel].self, from: localStorePendingFiles)
                } catch {
                    return []
                }
            }()
            
            pendingURLs.append(PendingFileModel(url: url, messageID: messageID))
            
            if let newData = try? JSONEncoder().encode(pendingURLs) {
                localStorePendingFiles = newData
                
                DispatchQueue.main.async {
                    completion(pendingURLs)
                }
            }
        } catch {
            print("Error creating temporary file: \(error)")
        }
        
    }
    
    func fetchSignedURL(key: Int64, chatID: Int, content_type: String, repliedTo: Int?, duration: String?) -> AnyPublisher<DataResponse<GetMessageSignedUrlResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)messages/pre-signed-url")!
        
        let params = GetMessageSignedUrlRequest(key: "chat-\(chatID)/messages/message-\(key).\(content_type == "video" ? "mov" : content_type == "audio" ? "m4a" : "jpg")",
                                         type: content_type,
                                         chatId: chatID,
                                         repliedTo: repliedTo,
                                         duration: duration)
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: params, url: url, responseType: GetMessageSignedUrlResponse.self)
    }
    
    func fetchChatMessages(roomID: Int, messageID: Int) -> AnyPublisher<DataResponse<MessagesListModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)messages")!
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["chatId" : roomID,
                                                                    "messageId" : messageID],
                                                           url: url, responseType: MessagesListModel.self)
    }
    
    func fetchChatId(userId: Int) -> AnyPublisher<DataResponse<GetChatIdResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)chats/get-chat-id")!
        return AlamofireAPIHelper.shared.post_patchRequest(params: ["userId" : userId], url: url, responseType: GetChatIdResponse.self)
        
    }
    
    func fetchChatList(page: Int, query: String) -> AnyPublisher<DataResponse<ChatListModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)chats")!
        let params = GetChatListRequest(page: page, search: query)
        return AlamofireAPIHelper.shared.post_patchRequest(params: params, url: url, responseType: ChatListModel.self)
        
    }
    
    func fetchInterlocutors() -> AnyPublisher<DataResponse<InterlocutorsListModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)chats/interlocutors")!
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: InterlocutorsListModel.self)
    }
}
