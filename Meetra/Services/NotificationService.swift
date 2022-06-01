//
//  NotificationService.swift
//  Meetra
//
//  Created by Karen Mirakyan on 16.03.22.
//

import Foundation
import Combine
import Alamofire

protocol NotificationServiceProtocol {
    func sendDeviceToken( token: String, deviceToken: String ) -> AnyPublisher<GlobalResponse, Error>
    func fetchNotifications(page: Int) -> AnyPublisher<DataResponse<NotificationListModel, NetworkError>, Never>
}

class NotificationService {
    static let shared: NotificationServiceProtocol = NotificationService()
    private init() { }
}

extension NotificationService: NotificationServiceProtocol {
    func fetchNotifications(page: Int) -> AnyPublisher<DataResponse<NotificationListModel, NetworkError>, Never> {
        let url = URL(string: "\(Credentials.BASE_URL)notifications/\(page)")!
        return AlamofireAPIHelper.shared.get_deleteRequest(url: url, responseType: NotificationListModel.self)
    }
    
    func sendDeviceToken( token: String, deviceToken: String ) -> AnyPublisher<GlobalResponse, Error> {
        let url = URL(string: "\(Credentials.BASE_URL)users/add-device-token")!
        let headers: HTTPHeaders = ["Authorization": "Bearer \(token)"]
                
        return AF.request(url,
                          method: .post,
                          parameters: ["device_token" : deviceToken],
                          encoder: JSONParameterEncoder.default,
                          headers: headers)
            .validate()
            .publishDecodable(type: GlobalResponse.self)
            .value()
            .mapError{ $0 as Error }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
