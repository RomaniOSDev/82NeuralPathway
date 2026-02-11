//
//  Achievement.swift
//  82NeuralPathway
//

import Foundation

struct DailyChallenge: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let targetLevelIds: [Int]
    let reward: Int
    let date: Date
}
