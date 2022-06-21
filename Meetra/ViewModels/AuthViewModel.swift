//
//  AuthViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import Foundation
import Combine
import SwiftUI
import Alamofire

class AuthViewModel: AlertViewModel, ObservableObject {
    @AppStorage("token") private var token: String = ""
    @AppStorage("userId") private var userID: Int = 0
    @AppStorage( "initialToken" ) private var initialToken: String = ""
    @AppStorage( "user_phone_number" ) private var user_phone: String = "(954)411-11-33"
    @AppStorage( "user_phone_code" ) private var user_code: String = "7"
    @AppStorage( "user_phone_country" ) private var user_country: String = "RU"
    
    @Published var phoneNumber: String = ""
    @Published var country: String = "RU"
    @Published var code: String = "7"
    
    @Published var OTP: String = ""
    
    @Published var login: Bool = false
        
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var navigate: Bool = false
    @Published var proceedRegistration: Bool = false
    @Published var interests = [String]()
    @Published var selected_interests = [String]()
    
    @Published var imageKeys = [(Data, String)]()
    @Published var imagesCount: Int = 0
        
    private var cancellableSet: Set<AnyCancellable> = []

    var dataManager: AuthServiceProtocol
    
    init(dataManager: AuthServiceProtocol = AuthService.shared) {
        self.dataManager = dataManager
    }
    
    func sendVerificationCode() {
        loading = true
        
        dataManager.sendVerificationCode(phoneNumber: "+\(code)\(phoneNumber)")
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.initialToken = response.value!.accessToken
                    self.login = response.value!.login!
                    self.userID = response.value!.id
                    self.navigate = true
                }
            }.store(in: &cancellableSet)
    }
    
    func checkVerificationCode() {
        loading = true
        dataManager.checkVerificationCode(code: OTP)
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    
                    self.user_phone = self.phoneNumber
                    self.user_code = self.code
                    self.user_country = self.country
                    
                    
                    if self.login {
                        self.token = self.initialToken
                    } else {
                        self.proceedRegistration.toggle()
                    }                    
                }
            }.store(in: &cancellableSet)
    }

    func getPreSignedURL(images: [Data]) {
        Just(images)
            .setFailureType(to: NetworkError.self)
            .flatMap { (values) -> Publishers.MergeMany<AnyPublisher<DataResponse<GetSignedUrlResponse, NetworkError>, Never>> in
                let tasks = values.map { image -> AnyPublisher<DataResponse<GetSignedUrlResponse, NetworkError>, Never> in
                    let key = "users/\(Date().millisecondsSince1970)-\(UUID().uuidString).jpg"
                    self.imageKeys.append((image, key))
                    return self.dataManager.fetchSignedUrl(key: key)
                }
                return Publishers.MergeMany(tasks)
            }.collect()
            .sink(receiveCompletion: { (completion) in
                if case .failure(let error) = completion {
                    self.makeAlert(with: error, message: &self.alertMessage, alert: &self.showAlert)
                }
            }) { (allURLs) in
                let urls = allURLs.filter({$0.value != nil}).map{ $0.value!.url }
                self.upload(images: images, urls: urls)
            }.store(in: &cancellableSet)
    }
    
    func upload(images: [Data], urls: [String]) {

        Just(zip(images, urls))
            .setFailureType(to: AFError.self)
            .flatMap { sequence -> Publishers.MergeMany<AnyPublisher<DataResponse<Data?, AFError>, Never>> in
                let tasks = sequence.map { (image, url) -> AnyPublisher<DataResponse<Data?, AFError>, Never> in
                    return self.dataManager.storeFileToServer(file: image, url: url)
                }
                return Publishers.MergeMany(tasks)
            }.collect()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.alertMessage = error.localizedDescription
                    self.showAlert.toggle()
                }
            }) { result in
                self.imagesCount = result.map{ $0.value }.count
                if self.imagesCount != images.count {
                    self.alertMessage = "Some of the images were not able to upload to server!"
                    self.showAlert.toggle()
                }
            }.store(in: &cancellableSet)
    }
    
    func resendVerificationCode() {
        dataManager.resendVerificationCode()
            .sink { _ in
            }.store(in: &cancellableSet)
    }
    
    func getInterests() {
        loading = true
        dataManager.fetchInterests()
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.interests = response.value!.interests
                }
            }.store(in: &cancellableSet)
    }
    
    func confirmSignUp(model: RegistrationRequest) {
        loading = true
        dataManager.signUpConfirm(model: model)
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.navigate = true
                }
            }.store(in: &cancellableSet)
    }
}
