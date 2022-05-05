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

protocol ChatServiceProtocol {
    func fetchChatList(page: Int, query: String) -> AnyPublisher<DataResponse<ChatListModel, NetworkError>, Never>
    func fetchInterlocutors() -> AnyPublisher<DataResponse<InterlocutorsListModel, NetworkError>, Never>
    
    func fetchChatId(userId: Int) -> AnyPublisher<DataResponse<GetChatIdResponse, NetworkError>, Never>
    func fetchChatMessages(roomID: Int, messageID: Int) -> AnyPublisher<DataResponse<MessagesListModel, NetworkError>, Never>
    func fetchSignedURL(key: Int64, chatID: Int, content_type: String) -> AnyPublisher<DataResponse<GetSignedUrlResponse, NetworkError>, Never>
    func storeLocalFile(withData: Data, messageID: Int, type: String, completion: @escaping() -> ())
}

class ChatService {
    static let shared: ChatServiceProtocol = ChatService()
    private init() { }
}

extension ChatService: ChatServiceProtocol {

    func storeLocalFile(withData: Data, messageID: Int, type: String, completion: @escaping() -> ()) {
        @AppStorage( "pending_files") var localStorePendingFiles: Data = Data()

        let directory = FileManager.default.temporaryDirectory
        let fileName = "\(NSUUID().uuidString).\(type == "video" ? "mov" : "jpg")"
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
                    completion()
                }
            }
            // store url and message id locally
//            if let pendingURLsDecoded = try? JSONDecoder().decode([PendingFileModel].self, from: localStorePendingFiles) {
//                var pendingURLs = pendingURLsDecoded
//                print("Decoded pending urls array = \(pendingURLs)")
//                pendingURLs.append(PendingFileModel(url: url, messageID: messageID))
//                print("New pending urls array = \(pendingURLs)")
//
//                if let newData = try? JSONEncoder().encode(pendingURLs) {
//                    localStorePendingFiles = newData
//
//                    DispatchQueue.main.async {
//                        completion()
//                    }
//                }
//            }
        } catch {
            print("Error creating temporary file: \(error)")
        }
        
    }
    
    func fetchSignedURL(key: Int64, chatID: Int, content_type: String) -> AnyPublisher<DataResponse<GetSignedUrlResponse, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)messages/pre-signed-url")!
        let params = GetSignedUrlRequest(key: "chat-\(chatID)/messages/message-\(key).png",
                                         type: content_type,
                                         chatId: chatID)
        
        return AlamofireAPIHelper.shared.post_patchRequest(params: params, url: url, responseType: GetSignedUrlResponse.self)
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
