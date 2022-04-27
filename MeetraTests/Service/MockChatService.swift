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
    func fetchChatList(page: Int) -> AnyPublisher<DataResponse<ChatListModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchChatsError, response: AppPreviewModels.chatListModel, responseType: ChatListModel.self)
    }
    
    func fetchInterlocutors(page: Int) -> AnyPublisher<DataResponse<InterlocutorsListModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchInterlocutorsError, response: AppPreviewModels.interlocutorsListModel, responseType: InterlocutorsListModel.self)
    }
    
    var fetchChatsError: Bool = false
    var fetchInterlocutorsError: Bool = false
}
