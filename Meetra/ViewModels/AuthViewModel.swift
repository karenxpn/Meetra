//
//  AuthViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import Foundation
import Combine
import SwiftUI

class AuthViewModel: AlertViewModel, ObservableObject {
    @AppStorage("token") private var token: String = ""
    
    @Published var phoneNumber: String = ""
    @Published var country: String = "RU"
    @Published var code: String = "7"
        
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var navigate: Bool = false
    @Published var interests = [InterestModel]()
    @Published var selected_interests = [String]()
    
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
                    self.navigate = true
                }
            }.store(in: &cancellableSet)
    }
    
    func checkVerificationCode(phone: String, code: String) {
        loading = true
        dataManager.checkVerificationCode(phoneNumber: phone, code: code)
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.navigate = true
                    // navigate
                }
            }.store(in: &cancellableSet)
    }
    
    func resendVerificationCode(phone: String) {
        dataManager.resendVerificationCode(phoneNumber: phone)
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
                    self.interests = response.value!
                }
            }.store(in: &cancellableSet)
    }
    
    func confirmSignUp(model: RegistrationRequest) {
        loading = true
        dataManager.signUpConfirm(model: model)
            .sink { response in
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.token = response.value!.token
                }
            }.store(in: &cancellableSet)
        
    }
}
