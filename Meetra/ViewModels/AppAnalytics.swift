//
//  Analytics.swift
//  Meetra
//
//  Created by Karen Mirakyan on 13.09.22.
//

import Foundation
import AppTrackingTransparency
import FirebaseAnalytics

struct AppAnalytics {
    func logEvent(event: String) {
        if ATTrackingManager.trackingAuthorizationStatus == .authorized {
            Analytics.logEvent(event, parameters: nil)
        }
    }
    
    func logScreenEvent(viewName: String) {
        if ATTrackingManager.trackingAuthorizationStatus == .authorized {
            Analytics.logEvent(AnalyticsEventScreenView,
                               parameters: [AnalyticsParameterScreenName: viewName,
                                           AnalyticsParameterScreenClass: viewName])
        }
    }
}
