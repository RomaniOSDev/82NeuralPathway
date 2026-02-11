//
//  LevelDataService.swift
//  82NeuralPathway
//

import SwiftUI

protocol LevelDataServiceProtocol {
    func level(for id: Int) -> Level?
    func allLevels(upTo maxId: Int) -> [Level]
}

final class LevelDataService: LevelDataServiceProtocol {
    func level(for id: Int) -> Level? {
        switch id {
        case 1: return Level(id: 1, chapter: 1, title: "First Connection", description: "Connect sensory to motor.", problem: "If input ON, output ON.", inputCount: 1, outputCount: 1, testCasesData: [TestCase(inputs: [1], outputs: [1]), TestCase(inputs: [0], outputs: [0])], maxNeurons: 8, maxConnections: 20, allowedNeuronTypes: [.sensory, .motor], optimalNeurons: 2, optimalConnections: 1, hint: "Drag from blue to green.")
        case 2: return Level(id: 2, chapter: 1, title: "Direct Path", description: "Create a simple reflex.", problem: "Input 1.0 → motor activates.", inputCount: 1, outputCount: 1, testCasesData: [TestCase(inputs: [1], outputs: [1]), TestCase(inputs: [0], outputs: [0])], maxNeurons: 8, maxConnections: 20, allowedNeuronTypes: [.sensory, .motor], optimalNeurons: 2, optimalConnections: 1, hint: "Connect the neurons.")
        case 3: return Level(id: 3, chapter: 2, title: "AND Gate", description: "Both inputs ON → output ON.", problem: "Output = Input1 AND Input2", inputCount: 2, outputCount: 1, testCasesData: [TestCase(inputs: [1, 1], outputs: [1]), TestCase(inputs: [1, 0], outputs: [0]), TestCase(inputs: [0, 1], outputs: [0]), TestCase(inputs: [0, 0], outputs: [0])], maxNeurons: 10, maxConnections: 25, allowedNeuronTypes: [.sensory, .intermediate, .motor], optimalNeurons: 4, optimalConnections: 4, hint: "Use an intermediate neuron. Both inputs must activate it.")
        case 4: return Level(id: 4, chapter: 2, title: "OR Gate", description: "Either input → output.", problem: "Output = Input1 OR Input2", inputCount: 2, outputCount: 1, testCasesData: [TestCase(inputs: [1, 1], outputs: [1]), TestCase(inputs: [1, 0], outputs: [1]), TestCase(inputs: [0, 1], outputs: [1]), TestCase(inputs: [0, 0], outputs: [0])], maxNeurons: 10, maxConnections: 25, allowedNeuronTypes: [.sensory, .intermediate, .motor], optimalNeurons: 4, optimalConnections: 4, hint: "Connect both inputs to the output.")
        default: return Level(id: id, chapter: min(5, (id - 1) / 20 + 1), title: "Level \(id)", description: "Solve the challenge.", problem: "Complete the network.", inputCount: 1, outputCount: 1, testCasesData: [TestCase(inputs: [1], outputs: [1]), TestCase(inputs: [0], outputs: [0])], maxNeurons: 15, maxConnections: 30, allowedNeuronTypes: NeuronType.allCases, optimalNeurons: nil, optimalConnections: nil, hint: nil)
        }
    }
    func allLevels(upTo maxId: Int) -> [Level] { (1...maxId).compactMap { level(for: $0) } }
}
