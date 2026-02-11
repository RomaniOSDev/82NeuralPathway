//
//  LevelSelectPresenter.swift
//  82NeuralPathway
//

import SwiftUI
import Combine

@MainActor
final class LevelSelectPresenter: ObservableObject {
    @Published var levels: [Level] = []
    @Published var mode: GameMode = .campaign
    private let interactor: LevelSelectInteractorProtocol
    private weak var navigation: AppNavigationProtocol?
    init(interactor: LevelSelectInteractorProtocol, navigation: AppNavigationProtocol?) {
        self.interactor = interactor
        self.navigation = navigation
    }
    func configure(mode: GameMode) { self.mode = mode }
    func load() {
        levels = interactor.loadLevels(upTo: 20)
    }
    func selectLevel(_ id: Int) {
        guard isUnlocked(id) else { return }
        navigation?.navigate(to: .game(levelId: id, mode: mode))
    }
    func goBack() { navigation?.navigate(to: .modeSelect) }
    func isUnlocked(_ id: Int) -> Bool {
        mode == .practice ? true : interactor.isLevelUnlocked(id)
    }
    func stars(_ id: Int) -> Int { interactor.starsForLevel(id) }
}
