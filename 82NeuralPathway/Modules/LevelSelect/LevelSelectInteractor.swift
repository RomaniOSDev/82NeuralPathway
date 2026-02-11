//
//  LevelSelectInteractor.swift
//  82NeuralPathway
//

import Foundation

protocol LevelSelectInteractorProtocol {
    func loadLevels(upTo: Int) -> [Level]
    func isLevelUnlocked(_ id: Int) -> Bool
    func starsForLevel(_ id: Int) -> Int
}

final class LevelSelectInteractor: LevelSelectInteractorProtocol {
    private let levelService: LevelDataServiceProtocol
    private let progression: ProgressionServiceProtocol
    init(levelService: LevelDataServiceProtocol = LevelDataService(), progression: ProgressionServiceProtocol = ProgressionService()) {
        self.levelService = levelService
        self.progression = progression
    }
    func loadLevels(upTo maxId: Int) -> [Level] { levelService.allLevels(upTo: maxId) }
    func isLevelUnlocked(_ id: Int) -> Bool { progression.isLevelUnlocked(id) }
    func starsForLevel(_ id: Int) -> Int { progression.starsForLevel(id) }
}
