//
//  AchievementService.swift
//  82NeuralPathway
//

import Foundation
import Combine

struct AchievementDefinition: Identifiable {
    let id: String
    let title: String
    let description: String
    let iconName: String
}

struct AchievementWithStatus: Identifiable {
    let definition: AchievementDefinition
    let isUnlocked: Bool
    var id: String { definition.id }
}

protocol AchievementServiceProtocol {
    func achievements(progression: ProgressionServiceProtocol) -> [AchievementWithStatus]
}

final class AchievementService: AchievementServiceProtocol {
    func achievements(progression: ProgressionServiceProtocol) -> [AchievementWithStatus] {
        let defs: [(String, String, String, String, (ProgressionServiceProtocol) -> Bool)] = [
            ("first", "First Step", "Complete level 1", "star.fill", { $0.completedLevels.contains(1) }),
            ("third", "On a Roll", "Complete level 3", "star.leadinghalf.filled", { $0.completedLevels.contains(3) }),
            ("five", "Half Dozen", "Complete level 5", "5.circle.fill", { $0.completedLevels.contains(5) }),
            ("ten", "Getting Started", "Complete 10 levels", "flame.fill", { $0.completedLevels.count >= 10 }),
            ("fifteen", "Rising Star", "Complete 15 levels", "sparkles", { $0.completedLevels.count >= 15 }),
            ("twenty", "Dedicated", "Complete 20 levels", "trophy.fill", { $0.completedLevels.count >= 20 }),
            ("chapter1", "Chapter 1 Complete", "Finish Simple Reflexes", "book.fill", { $0.completedLevels.contains(20) }),
            ("star_5", "Star Collector", "Earn 5 stars total", "star.circle", { $0.levelStars.values.reduce(0, +) >= 5 }),
            ("star_10", "Shining", "Earn 10 stars total", "star.circle.fill", { $0.levelStars.values.reduce(0, +) >= 10 }),
            ("star_20", "Constellation", "Earn 20 stars total", "star.and.crescent.fill", { $0.levelStars.values.reduce(0, +) >= 20 }),
            ("star_30", "Galaxy", "Earn 30 stars total", "sparkle", { $0.levelStars.values.reduce(0, +) >= 30 }),
            ("star_master", "Star Master", "Get 3 stars on 5 levels", "crown.fill", { $0.levelStars.values.filter { $0 >= 3 }.count >= 5 }),
            ("star_perfect", "Perfectionist", "Get 3 stars on 10 levels", "crown", { $0.levelStars.values.filter { $0 >= 3 }.count >= 10 }),
            ("and_gate", "Logic Pro", "Complete AND Gate level", "function", { $0.completedLevels.contains(3) }),
            ("or_gate", "Either Way", "Complete OR Gate level", "arrow.triangle.branch", { $0.completedLevels.contains(4) }),
            ("neural_net", "Network Builder", "Complete 4 levels in a row", "point.3.connected.trianglepath.dotted", { $0.completedLevels.contains(4) })
        ]
        return defs.map { id, title, desc, icon, check in
            AchievementWithStatus(
                definition: AchievementDefinition(id: id, title: title, description: desc, iconName: icon),
                isUnlocked: check(progression)
            )
        }
    }
}
