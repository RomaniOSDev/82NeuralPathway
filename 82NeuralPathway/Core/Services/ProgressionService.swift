//
//  ProgressionService.swift
//  82NeuralPathway
//

import Foundation

struct LevelProgress: Codable {
    var completedLevels: Set<Int>
    var levelStars: [Int: Int]
    var totalStars: Int
}

protocol ProgressionServiceProtocol {
    var completedLevels: Set<Int> { get }
    var levelStars: [Int: Int] { get }
    func completeLevel(_ id: Int, stars: Int)
    func isLevelUnlocked(_ id: Int) -> Bool
    func starsForLevel(_ id: Int) -> Int
}

final class ProgressionService: ProgressionServiceProtocol {
    private let persistence: PersistenceServiceProtocol
    private let key = "progression"
    private var progress: LevelProgress {
        get { persistence.load(LevelProgress.self, forKey: key) ?? LevelProgress(completedLevels: [], levelStars: [:], totalStars: 0) }
        set { persistence.save(newValue, forKey: key) }
    }
    init(persistence: PersistenceServiceProtocol = PersistenceService()) {
        self.persistence = persistence
    }
    var completedLevels: Set<Int> { progress.completedLevels }
    var levelStars: [Int: Int] { progress.levelStars }
    func completeLevel(_ id: Int, stars: Int) {
        var p = progress
        p.completedLevels.insert(id)
        let oldStars = p.levelStars[id] ?? 0
        p.levelStars[id] = max(oldStars, stars)
        p.totalStars = p.levelStars.values.reduce(0, +)
        progress = p
    }
    func isLevelUnlocked(_ id: Int) -> Bool { id == 1 || progress.completedLevels.contains(id - 1) }
    func starsForLevel(_ id: Int) -> Int { progress.levelStars[id] ?? 0 }
}
