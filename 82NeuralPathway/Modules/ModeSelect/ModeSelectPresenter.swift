//
//  ModeSelectPresenter.swift
//  82NeuralPathway
//

import SwiftUI
import Combine

@MainActor
final class ModeSelectPresenter: ObservableObject {
    @Published var modes: [GameMode] = GameMode.allCases
    private weak var navigation: AppNavigationProtocol?

    init(navigation: AppNavigationProtocol?) {
        self.navigation = navigation
    }

    func selectMode(_ mode: GameMode) {
        switch mode {
        case .campaign:
            navigation?.navigate(to: .levelSelect(mode: .campaign))
        case .practice:
            navigation?.navigate(to: .levelSelect(mode: .practice))
        case .sandbox:
            navigation?.navigate(to: .sandbox)
        case .challenge:
            let challengeLevelId = generateDailyChallengeLevel()
            navigation?.navigate(to: .challenge(levelId: challengeLevelId))
        }
    }

    func goBack() {
        navigation?.navigate(to: .menu)
    }

    private func generateDailyChallengeLevel() -> Int {
        let dayOfYear = Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
        return (dayOfYear % 4) + 1
    }
}
