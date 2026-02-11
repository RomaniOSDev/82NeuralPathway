//
//  ProgressionInteractor.swift
//  82NeuralPathway
//

import Foundation

protocol ProgressionInteractorProtocol {
    func loadAchievements() -> [AchievementWithStatus]
    func completedLevelsCount() -> Int
    func totalStars() -> Int
}

final class ProgressionInteractor: ProgressionInteractorProtocol {
    private let achievementService: AchievementServiceProtocol
    private let progression: ProgressionServiceProtocol
    init(achievementService: AchievementServiceProtocol = AchievementService(),
         progression: ProgressionServiceProtocol = ProgressionService()) {
        self.achievementService = achievementService
        self.progression = progression
    }
    func loadAchievements() -> [AchievementWithStatus] {
        achievementService.achievements(progression: progression)
    }
    func completedLevelsCount() -> Int { progression.completedLevels.count }
    func totalStars() -> Int { progression.levelStars.values.reduce(0, +) }
}
