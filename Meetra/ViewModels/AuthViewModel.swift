//
//  AuthViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 01.03.22.
//

import Foundation
import Combine

class AuthViewModel: AlertViewModel, ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var country: String = "RU"
    @Published var code: String = "7"
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Published var navigateToCheckVerification: Bool = false
    
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
                    self.navigateToCheckVerification = true
                }
            }.store(in: &cancellableSet)
    }
}
