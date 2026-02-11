//
//  OnboardingService.swift
//  82NeuralPathway
//

import Foundation

protocol OnboardingServiceProtocol {
    var hasCompletedOnboarding: Bool { get }
    func completeOnboarding()
}

final class OnboardingService: OnboardingServiceProtocol {
    private let persistence: PersistenceServiceProtocol
    private let key = "onboardingCompleted"
    init(persistence: PersistenceServiceProtocol = PersistenceService()) {
        self.persistence = persistence
    }
    var hasCompletedOnboarding: Bool {
        (persistence.load(Bool.self, forKey: key) ?? false)
    }
    func completeOnboarding() {
        persistence.save(true, forKey: key)
    }
}
