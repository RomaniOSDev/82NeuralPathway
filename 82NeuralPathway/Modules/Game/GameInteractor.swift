//
//  GameInteractor.swift
//  82NeuralPathway
//

import SwiftUI

protocol GameInteractorProtocol {
    func loadLevel(_ id: Int, canvasWidth: CGFloat) -> Level?
    func loadSandbox(canvasWidth: CGFloat) -> Level?
    func runSimulation(network: NeuralNetwork, level: Level, saveProgress: Bool) -> (passed: Bool, stars: Int, efficiency: Double)
    func saveSnapshot(_ snapshot: NetworkSnapshot)
    func popSnapshot() -> NetworkSnapshot?
    func canUndo() -> Bool
}

final class GameInteractor: GameInteractorProtocol {
    private let levelService: LevelDataServiceProtocol
    private let progression: ProgressionServiceProtocol
    private let undoService: UndoServiceProtocol
    init(levelService: LevelDataServiceProtocol = LevelDataService(),
         progression: ProgressionServiceProtocol = ProgressionService(),
         undoService: UndoServiceProtocol = UndoService()) {
        self.levelService = levelService
        self.progression = progression
        self.undoService = undoService
    }
    func loadLevel(_ id: Int, canvasWidth: CGFloat) -> Level? {
        undoService.clear()
        return levelService.level(for: id)
    }
    func loadSandbox(canvasWidth: CGFloat) -> Level? {
        undoService.clear()
        return Level(id: 0, chapter: 1, title: "Sandbox", description: "Free build", problem: "Create your own network", inputCount: 1, outputCount: 1, testCasesData: [], maxNeurons: 99, maxConnections: 99, allowedNeuronTypes: NeuronType.allCases, optimalNeurons: nil, optimalConnections: nil, hint: nil)
    }
    func runSimulation(network: NeuralNetwork, level: Level, saveProgress: Bool) -> (passed: Bool, stars: Int, efficiency: Double) {
        var allPassed = true
        for tc in level.testCasesData {
            let out = network.activate(with: tc.inputs)
            for (i, exp) in tc.outputs.enumerated() {
                if i >= out.count || abs(out[i] - exp) > 0.5 { allPassed = false; break }
            }
        }
        let used = Double(network.neurons.count + network.connections.count)
        let maxUsed = Double(level.maxNeurons + level.maxConnections)
        let efficiency = maxUsed > 0 ? (1 - used / maxUsed) * 100 : 0
        var stars = allPassed ? 1 : 0
        if allPassed {
            if let optN = level.optimalNeurons, let optC = level.optimalConnections,
               network.neurons.count <= optN && network.connections.count <= optC { stars = 3 }
            else if efficiency > 50 { stars = 2 }
            if saveProgress { progression.completeLevel(level.id, stars: stars) }
        }
        return (allPassed, stars, efficiency)
    }
    func saveSnapshot(_ snapshot: NetworkSnapshot) { undoService.push(snapshot) }
    func popSnapshot() -> NetworkSnapshot? { undoService.pop() }
    func canUndo() -> Bool { undoService.canUndo }
}
