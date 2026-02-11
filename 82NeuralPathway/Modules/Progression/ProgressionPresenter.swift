//
//  ProgressionPresenter.swift
//  82NeuralPathway
//

import SwiftUI
import Combine

@MainActor
final class ProgressionPresenter: ObservableObject {
    @Published var achievements: [AchievementWithStatus] = []
    @Published var completedLevels = 0
    @Published var totalStars = 0
    private let interactor: ProgressionInteractorProtocol
    private weak var navigation: AppNavigationProtocol?
    init(interactor: ProgressionInteractorProtocol, navigation: AppNavigationProtocol?) {
        self.interactor = interactor
        self.navigation = navigation
    }
    func load() {
        achievements = interactor.loadAchievements()
        completedLevels = interactor.completedLevelsCount()
        totalStars = interactor.totalStars()
    }
    func goBack() { navigation?.navigate(to: .menu) }
}
