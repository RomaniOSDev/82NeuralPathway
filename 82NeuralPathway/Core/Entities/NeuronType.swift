//
//  NeuronType.swift
//  82NeuralPathway
//

import SwiftUI

enum NeuronShape: String, Codable {
    case circle, hexagon, triangle
}

enum NeuronType: String, CaseIterable, Codable, Hashable {
    case sensory, intermediate, motor
    var color: Color {
        switch self {
        case .sensory: return NeuralPathwayColors.sensoryNeuron
        case .intermediate: return NeuralPathwayColors.intermediateNeuron
        case .motor: return NeuralPathwayColors.motorNeuron
        }
    }
    var shape: NeuronShape {
        switch self {
        case .sensory: return .circle
        case .intermediate: return .hexagon
        case .motor: return .triangle
        }
    }
    var activationThreshold: Double {
        switch self {
        case .sensory: return 0.1
        case .intermediate: return 0.5
        case .motor: return 0.7
        }
    }
    var displayName: String {
        switch self {
        case .sensory: return "Sensory"
        case .intermediate: return "Intermediate"
        case .motor: return "Motor"
        }
    }
}
