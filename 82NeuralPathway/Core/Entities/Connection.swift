//
//  Connection.swift
//  82NeuralPathway
//

import SwiftUI

struct Connection: Identifiable, Equatable, Codable {
    let id: UUID
    let fromNeuronID: UUID
    let toNeuronID: UUID
    var weight: Double
    var delay: Int

    init(id: UUID = UUID(), fromNeuronID: UUID, toNeuronID: UUID, weight: Double = 1, delay: Int = 0) {
        self.id = id
        self.fromNeuronID = fromNeuronID
        self.toNeuronID = toNeuronID
        self.weight = min(1, max(-1, weight))
        self.delay = max(0, delay)
    }

    var visualWeight: CGFloat { CGFloat(abs(weight)) * 3 + 1 }
    var connectionColor: Color {
        if weight > 0 {
            return NeuralPathwayColors.sensoryNeuron.interpolate(to: NeuralPathwayColors.motorNeuron, amount: weight)
        } else {
            return Color.red.interpolate(to: Color.orange, amount: abs(weight))
        }
    }
}
