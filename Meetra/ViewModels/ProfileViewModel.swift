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
    @AppStorage( "initialToken" ) var initialToken: String = ""
    @AppStorage( "user_phone_number" ) private var user_phone: String = "(954)411-11-33"
    @AppStorage( "user_phone_code" ) private var user_code: String = "7"
    @AppStorage( "user_phone_country" ) private var user_country: String = "RU"
    
    @Published var loading: Bool = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var interests = [String]()
    
    @Published var profile: ProfileModel? = nil
    @Published var editFields: ProfileEditFieldsViewModel? = nil
    @Published var profileImages = [ProfileImageModel]()
    
    
    /// change phone number
    @Published var phoneNumber: String = ""
    @Published var country: String = "RU"
    @Published var code: String = "7"
    
    @Published var OTP: String = ""
    @Published var navigateToCheck: Bool = false
    ///
    
    private var cancellableSet: Set<AnyCancellable> = []
    var dataManager: ProfileServiceProtocol
    var authDataManager: AuthServiceProtocol
    
    init( dataManager: ProfileServiceProtocol = ProfileService.shared,
          authDataManager: AuthServiceProtocol = AuthService.shared ) {
        self.dataManager = dataManager
        self.authDataManager = authDataManager
        
        super.init()
        
        self.country = self.user_country
        self.code = self.user_code
    }
    
    func getProfile() {
        loading = true
        dataManager.fetchProfile()
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
        Publishers.Zip(dataManager.fetchProfileEditFields(),
                       dataManager.fetchProfileImages())
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
        dataManager.updateProfile(model: fields)
            .sink { response in
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("updated"), object: nil)
                }
            }.store(in: &cancellableSet)
    }
    
    func updateProfileImages( images: [String] ) {
        dataManager.updateProfileImages(images: images)
            .sink { response in
                if response.error != nil {
                    self.profileImages.removeAll(where: {!$0.image.hasPrefix("https:/")})
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.profileImages.removeAll(where: {!$0.image.hasPrefix("https:/")})
                    self.profileImages.append(contentsOf: response.value!.images )
                }
            }.store(in: &cancellableSet)
    }
    
    func updateAvatar(id: Int) {
        dataManager.updateProfileImage(id: id)
            .sink { response in
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    if let index = self.profileImages.firstIndex(where: { $0.id == id}) {
                        withAnimation {
                            self.profileImages.move(from: index, to: 0)
                        }
                    }
                }
            }.store(in: &cancellableSet)
    }
    
    func deleteProfileImage(id: Int) {
        dataManager.deleteProfileImage(id: id)
            .sink { response in
                if response.error == nil {
                    self.profileImages.removeAll(where: { $0.id == id })
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
    
    func sendVerificationCode() {
        AppAnalytics().logEvent(event: "send_verification_code_profile")
        loading = true
        dataManager.sendVerificationCode(phoneNumber: "+\(code)\(phoneNumber)")
            .sink { response in
                self.loading = false
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    self.navigateToCheck = true
                }
            }.store(in: &cancellableSet)
    }
    
    func checkVerificationCode() {
        AppAnalytics().logEvent(event: "check_verification_code")
        dataManager.checkVerificationCode(phoneNumber: "+\(code)\(phoneNumber)", code: OTP)
            .sink { response in
                if response.error != nil {
                    self.makeAlert(with: response.error!, message: &self.alertMessage, alert: &self.showAlert)
                } else {
                    NotificationCenter.default.post(name: Notification.Name("phone_updated"), object: nil)
                    self.user_phone = self.phoneNumber
                    self.user_code = self.code
                    self.user_country = self.country
                    
                    self.phoneNumber = ""
                    self.OTP = ""
                }
            }.store(in: &cancellableSet)
    }
    
    func logout() {
        AppAnalytics().logEvent(event: "sighout_account")
        dataManager.signout()
            .sink { response in
                if response.error == nil {
                    self.token = ""
                    self.initialToken = ""
                }
            }.store(in: &cancellableSet)
    }
    
    func deactivateAccount() {
        AppAnalytics().logEvent(event: "delete_account")
        dataManager.delete_account()
            .sink { response in
                if response.error == nil {
                    self.token = ""
                }
            }.store(in: &cancellableSet)
    }
}
