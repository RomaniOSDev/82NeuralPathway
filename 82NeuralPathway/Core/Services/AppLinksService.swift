//
//  AppLinksService.swift
//  82NeuralPathway
//

import Foundation
import UIKit
import StoreKit

enum AppLinks {
    static let privacyPolicy = "https://www.termsfeed.com/live/665301de-c242-4033-bb89-a1821cf6dc83"
    static let termsOfService = "https://www.termsfeed.com/live/827e98bb-c0cb-4bdb-8521-0d4b4e886552"

    static func openPrivacy() {
        if let url = URL(string: privacyPolicy) {
            UIApplication.shared.open(url)
        }
    }

    static func openTerms() {
        if let url = URL(string: termsOfService) {
            UIApplication.shared.open(url)
        }
    }

    static func rateApp() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
        }
    }
}
