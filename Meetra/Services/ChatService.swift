//
//  ChatService.swift
//  Meetra
//
//  Created by Karen Mirakyan on 25.04.22.
//

import Foundation
import Combine
import Alamofire

protocol ChatServiceProtocol {
    func fetchChatList(page: Int, query: String) -> AnyPublisher<DataResponse<ChatListModel, NetworkError>, Never>
    func fetchInterlocutors() -> AnyPublisher<DataResponse<InterlocutorsListModel, NetworkError>, Never>
}

class ChatService {
    static let shared: ChatServiceProtocol = ChatService()
    private init() { }
}

extension ChatService: ChatServiceProtocol {
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
