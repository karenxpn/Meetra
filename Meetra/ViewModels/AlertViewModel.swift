//
//  AlertViewModel.swift
//  Meetra
//
//  Created by Karen Mirakyan on 02.03.22.
//

import Foundation
import SwiftUI

class AlertViewModel {
    
    @AppStorage("token") private var token: String = ""
    
    func makeAlert(with error: NetworkError, message: inout String, alert: inout Bool ) {
        
        if error.initialError.responseCode == 401 {
            self.token = ""
            
        } else {
            message = error.backendError == nil ? error.initialError.localizedDescription : error.backendError!.message
            alert.toggle()
        }
    }
    
//    func makeSuccessAlert( with response: GlobalResponse, showAlert: inout Bool, alertMessage: inout String ) {
//        alertMessage = response.message
//        showAlert.toggle()
//    }
//
//    func makeReportAlert( response: GlobalResponse, alert: inout Bool, message: inout String, type: inout UserStatusChangeAlert? ) {
//        message = response.message
//        type = .report
//        alert.toggle()
//    }
}
