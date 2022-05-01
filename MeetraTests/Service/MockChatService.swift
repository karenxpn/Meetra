//
//  MockChatService.swift
//  MeetraTests
//
//  Created by Karen Mirakyan on 27.04.22.
//

import Foundation
import Alamofire
import Combine
@testable import Meetra

class MockChatService: ChatServiceProtocol {
    func fetchChatList(page: Int, query: String) -> AnyPublisher<DataResponse<ChatListModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchChatsError, response: AppPreviewModels.chatListModel, responseType: ChatListModel.self)
    }
    
    func fetchChatId(userId: Int) -> AnyPublisher<DataResponse<GetChatIdResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchChatIdError, response: getChatIdResponse, responseType: GetChatIdResponse.self)
    }
    
    func fetchInterlocutors() -> AnyPublisher<DataResponse<InterlocutorsListModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchInterlocutorsError, response: AppPreviewModels.interlocutorsListModel, responseType: InterlocutorsListModel.self)
    }
    
    var fetchChatsError: Bool = false
    var fetchInterlocutorsError: Bool = false
    var fetchChatIdError: Bool = false
    
    let getChatIdResponse = GetChatIdResponse(chat: 1)
}
