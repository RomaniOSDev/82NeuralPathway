//
//  GameMode.swift
//  82NeuralPathway
//

import SwiftUI

enum GameMode: String, CaseIterable, Identifiable {
    case campaign
    case practice
    case sandbox
    case challenge
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .campaign: return "Campaign"
        case .practice: return "Practice"
        case .sandbox: return "Sandbox"
        case .challenge: return "Challenge"
        }
    }
    
    var description: String {
        switch self {
        case .campaign: return "Level-based progression with stars"
        case .practice: return "Unlimited resources to learn"
        case .sandbox: return "Free build with no objectives"
        case .challenge: return "Special daily challenges"
        }
    }
    
    var iconName: String {
        switch self {
        case .campaign: return "flag.fill"
        case .practice: return "book.fill"
        case .sandbox: return "square.stack.3d.up.fill"
        case .challenge: return "bolt.fill"
        }
    }
}
