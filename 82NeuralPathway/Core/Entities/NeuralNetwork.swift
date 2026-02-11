//
//  NeuralNetwork.swift
//  82NeuralPathway
//

import SwiftUI
import Combine

final class NeuralNetwork: ObservableObject {
    @Published var neurons: [Neuron] = []
    @Published var connections: [Connection] = []
    var inputs: [UUID] = []
    var outputs: [UUID] = []

    func resetActivation() {
        for i in neurons.indices { neurons[i].reset() }
    }

    func activate(with inputValues: [Double]) -> [Double] {
        resetActivation()
        for (index, inputID) in inputs.enumerated() where index < inputValues.count {
            if let idx = neurons.firstIndex(where: { $0.id == inputID }) {
                neurons[idx].addActivation(inputValues[index])
            }
        }
        var changed = true
        var iterations = 0
        while changed, iterations < 100 {
            changed = false
            var newNeurons = neurons
            for neuron in neurons where neuron.isActive {
                for conn in connections where conn.fromNeuronID == neuron.id {
                    if let targetIdx = neurons.firstIndex(where: { $0.id == conn.toNeuronID }) {
                        let signal = neuron.activation * conn.weight
                        let old = newNeurons[targetIdx].activation
                        newNeurons[targetIdx].addActivation(signal)
                        if newNeurons[targetIdx].activation != old { changed = true }
                    }
                }
            }
            neurons = newNeurons
            iterations += 1
        }
        return outputs.compactMap { id in neurons.first(where: { $0.id == id })?.activation }
    }

    func addNeuron(_ type: NeuronType, at position: CGPoint) -> Neuron {
        let neuron = Neuron(type: type, position: position)
        neurons.append(neuron)
        return neuron
    }

    func addConnection(from: UUID, to: UUID, weight: Double = 1) {
        guard from != to,
              neurons.contains(where: { $0.id == from }),
              neurons.contains(where: { $0.id == to }),
              !connections.contains(where: { $0.fromNeuronID == from && $0.toNeuronID == to })
        else { return }
        connections.append(Connection(fromNeuronID: from, toNeuronID: to, weight: weight))
    }

    func removeNeuron(id: UUID) {
        neurons.removeAll { $0.id == id }
        connections.removeAll { $0.fromNeuronID == id || $0.toNeuronID == id }
        inputs.removeAll { $0 == id }
        outputs.removeAll { $0 == id }
    }

    func removeConnection(id: UUID) {
        connections.removeAll { $0.id == id }
    }

    func updateConnectionWeight(id: UUID, delta: Double) {
        if let idx = connections.firstIndex(where: { $0.id == id }) {
            connections[idx].weight = min(1, max(-1, connections[idx].weight + delta))
        }
    }

    func moveNeuron(id: UUID, to position: CGPoint) {
        if let idx = neurons.firstIndex(where: { $0.id == id }) {
            neurons[idx].position = position
        }
    }
}
