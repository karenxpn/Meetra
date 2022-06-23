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
    var changeChatNotificationStatusError: Bool = false
    func changeChatNotificationStatus(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: changeChatNotificationStatusError, response: globalResponse, responseType: GlobalResponse.self)
    }
    
    var deleteChatError: Bool = false
    func deleteChat(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: deleteChatError, response: globalResponse, responseType: GlobalResponse.self)

    }
    
    var markUnreadError: Bool = false
    func markUnread(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: markUnreadError, response: globalResponse, responseType: GlobalResponse.self)
    }
    
    var leaveChatError: Bool = false
    func leaveChat(id: Int) -> AnyPublisher<DataResponse<GlobalResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: leaveChatError, response: globalResponse, responseType: GlobalResponse.self)
    }
    
    var fetchSignedURLError: Bool = false
    func fetchSignedURL(key: Int64, chatID: Int, content_type: String, repliedTo: Int?, duration: String?) -> AnyPublisher<DataResponse<GetMessageSignedUrlResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchSignedURLError, response: AppPreviewModels.signedUrlResponse, responseType: GetMessageSignedUrlResponse.self)
    }
    
    
    var fetchNewConversationError: Bool = false
    func fetchNewConversationResponse(roomID: Int) -> AnyPublisher<DataResponse<NewConversationResponse, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchNewConversationError, response: AppPreviewModels.newConversation, responseType: NewConversationResponse.self)
    }
    
    var fetchMessagesError: Bool = false
    func fetchChatMessages(roomID: Int, messageID: Int) -> AnyPublisher<DataResponse<MessagesListModel, NetworkError>, Never> {
        return AlamofireAPIHelper.shared.mockRequest(error: fetchMessagesError, response: AppPreviewModels.messagesList, responseType: MessagesListModel.self)
    }
    
    func storeLocalFile(withData: Data, messageID: Int, type: String, completion: @escaping ([PendingFileModel]) -> ()) {
        
    }
    
    func storeFileToServer(file: Data, url: String, completion: @escaping (Bool) -> ()) {
        
    }
    
    func removeLocalFile(url: URL, messageID: Int, completion: @escaping () -> ()) {
        
    }
    
    func buffer(url: URL, samplesCount: Int, completion: @escaping ([AudioPreviewModel]) -> ()) {
        
    }
    
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
    let globalResponse = GlobalResponse(status: "status", message: "message")
}
