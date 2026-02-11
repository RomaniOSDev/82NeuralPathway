//
//  Neuron.swift
//  82NeuralPathway
//

import SwiftUI
import Combine

struct Neuron: Identifiable, Equatable, Codable {
    let id: UUID
    let type: NeuronType
    var position: CGPoint
    var activation: Double
    var isActive: Bool

    init(id: UUID = UUID(), type: NeuronType, position: CGPoint = .zero, activation: Double = 0, isActive: Bool = false) {
        self.id = id
        self.type = type
        self.position = position
        self.activation = activation
        self.isActive = isActive
    }

    mutating func addActivation(_ strength: Double) {
        activation = min(1, activation + strength)
        isActive = activation >= type.activationThreshold
    }

    mutating func reset() {
        activation = 0
        isActive = false
    }
}
