//
//  ProfileViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 06.04.22.
//

import Foundation
import Combine
import SwiftUI

class ProfileViewModel: AlertViewModel, ObservableObject {
    @AppStorage( "token" ) private var token: String = ""
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var interests = [String]()
    
    @Published var profile: ProfileModel? = nil
    @Published var editFields: ProfileEditFieldsViewModel? = nil
    @Published var profileImages = [String]()
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ProfileServiceProtocol
    var authDataManager: AuthServiceProtocol
    
    init( dataManager: ProfileServiceProtocol = ProfileService.shared,
          authDataManager: AuthServiceProtocol = AuthService.shared ) {
        self.dataManager = dataManager
        self.authDataManager = authDataManager
    }
    
    func getProfile() {
        loading = true
        dataManager.fetchProfile(token: token)
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.profile = response.value!
                }
            }.store(in: &cancellableSet)
    }
    
    func getProfileUpdateFields() {
        loading = true
        Publishers.Zip(dataManager.fetchProfileEditFields(token: token),
                       dataManager.fetchProfileImages(token: token))
        .sink { fields, images in
            self.loading = false
            if fields.error != nil || images.error != nil {
                self.makeAlert(with: fields.error == nil ? images.error! : fields.error!,
                               message: &self.alertMessage,
                               alert: &self.showAlert)
            } else {
                self.editFields = ProfileEditFieldsViewModel(fields: fields.value!)
                self.profileImages = images.value!.images
            }
        }.store(in: &cancellableSet)
    }
    
    func updateProfile(fields: ProfileEditFields) {
        dataManager.updateProfile(token: token, model: fields)
            .sink { response in
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("updated"), object: nil)
                }
            }.store(in: &cancellableSet)
    }
    
    func getInterests() {
        loading = true
        authDataManager.fetchInterests()
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.interests = response.value!.interests
                }
            }.store(in: &cancellableSet)
    }
}
