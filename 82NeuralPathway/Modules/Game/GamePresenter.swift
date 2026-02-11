//
//  GamePresenter.swift
//  82NeuralPathway
//

import SwiftUI
import Combine

enum SimulationState { case idle, running, success, failure }

@MainActor
final class GamePresenter: ObservableObject {
    @Published var network = NeuralNetwork()
    @Published var level: Level?
    @Published var simulationState: SimulationState = .idle
    @Published var selectedNeuronID: UUID?
    @Published var connectionInProgress: (from: UUID, position: CGPoint)?
    @Published var pendingNeuronType: NeuronType?
    @Published var showLevelComplete = false
    @Published var efficiency: Double = 0
    @Published var starsEarned = 0
    @Published var canUndo = false
    @Published var showHint = false
    @Published var canvasWidth: CGFloat = 400
    @Published var mode: GameMode = .campaign
    private let interactor: GameInteractorProtocol
    private weak var navigation: AppNavigationProtocol?
    init(interactor: GameInteractorProtocol, navigation: AppNavigationProtocol?) {
        self.interactor = interactor
        self.navigation = navigation
    }
    func configure(mode: GameMode) { self.mode = mode }
    var neuronLimit: Int {
        switch mode {
        case .practice: return 99
        case .sandbox: return 99
        case .challenge: return level?.maxNeurons ?? 15
        case .campaign: return level?.maxNeurons ?? 15
        }
    }
    var connectionLimit: Int {
        switch mode {
        case .practice: return 99
        case .sandbox: return 99
        case .challenge: return level?.maxConnections ?? 30
        case .campaign: return level?.maxConnections ?? 30
        }
    }
    func loadSandbox() {
        level = interactor.loadSandbox(canvasWidth: canvasWidth)
        guard let l = level else { return }
        network = NeuralNetwork()
        let startX: CGFloat = 100
        let rightX = canvasWidth - startX
        let centerY: CGFloat = 280
        let n1 = network.addNeuron(.sensory, at: CGPoint(x: startX, y: centerY))
        let n2 = network.addNeuron(.motor, at: CGPoint(x: rightX, y: centerY))
        network.inputs = [n1.id]
        network.outputs = [n2.id]
        simulationState = .idle
        selectedNeuronID = nil
        connectionInProgress = nil
        pendingNeuronType = nil
        canUndo = false
    }
    func loadLevel(_ levelId: Int) {
        level = interactor.loadLevel(levelId, canvasWidth: canvasWidth)
        guard let l = level else { return }
        network = NeuralNetwork()
        let spacing: CGFloat = 120
        let startX: CGFloat = 100
        let rightX = canvasWidth - startX
        let centerY: CGFloat = 280
        for i in 0..<l.inputCount {
            let n = network.addNeuron(.sensory, at: CGPoint(x: startX, y: centerY + CGFloat(i - l.inputCount/2) * spacing))
            network.inputs.append(n.id)
        }
        for i in 0..<l.outputCount {
            let n = network.addNeuron(.motor, at: CGPoint(x: rightX, y: centerY + CGFloat(i - l.outputCount/2) * spacing))
            network.outputs.append(n.id)
        }
        simulationState = .idle
        selectedNeuronID = nil
        connectionInProgress = nil
        pendingNeuronType = nil
        canUndo = false
    }
    func pushUndo() {
        interactor.saveSnapshot(NetworkSnapshot(neurons: network.neurons, connections: network.connections, inputs: network.inputs, outputs: network.outputs))
        canUndo = interactor.canUndo()
    }
    func undo() {
        guard let snap = interactor.popSnapshot() else { return }
        network.neurons = snap.neurons
        network.connections = snap.connections
        network.inputs = snap.inputs
        network.outputs = snap.outputs
        canUndo = interactor.canUndo()
    }
    func addNeuron(_ type: NeuronType, at position: CGPoint) {
        guard network.neurons.count < neuronLimit, level?.allowedNeuronTypes.contains(type) ?? true else { return }
        pushUndo()
        _ = network.addNeuron(type, at: position)
    }
    func startConnection(from id: UUID, at pos: CGPoint) { connectionInProgress = (id, pos) }
    func updateConnectionDrag(_ pos: CGPoint) {
        guard let from = connectionInProgress?.from else { return }
        connectionInProgress = (from, pos)
    }
    func endConnection(at _: CGPoint, on targetID: UUID?) {
        defer { connectionInProgress = nil }
        guard let from = connectionInProgress?.from, let to = targetID, from != to,
              network.connections.count < connectionLimit else { return }
        pushUndo()
        network.addConnection(from: from, to: to, weight: 1)
    }
    func cancelConnection() { connectionInProgress = nil }
    func selectNeuron(_ id: UUID?) { selectedNeuronID = id }
    func removeSelectedNeuron() {
        guard let id = selectedNeuronID else { return }
        pushUndo()
        network.removeNeuron(id: id)
        selectedNeuronID = nil
    }
    func moveNeuron(id: UUID, to pos: CGPoint) { network.moveNeuron(id: id, to: pos) }
    func setPendingNeuronType(_ t: NeuronType?) { pendingNeuronType = t }
    func runSimulation() {
        guard let l = level else { return }
        if l.testCasesData.isEmpty { return }
        simulationState = .running
        let saveProgress = (mode == .campaign || mode == .challenge)
        let (passed, stars, eff) = interactor.runSimulation(network: network, level: l, saveProgress: saveProgress)
        simulationState = passed ? .success : .failure
        starsEarned = stars
        efficiency = eff
        if passed { showLevelComplete = true }
    }
    func reset() {
        if mode == .sandbox { loadSandbox() }
        else { loadLevel(level?.id ?? 1) }
    }
    func toggleHint() { showHint.toggle() }
    func nextLevel() {
        guard let id = level?.id else { return }
        navigation?.navigate(to: .game(levelId: id + 1, mode: mode))
    }
    func goBack() {
        switch mode {
        case .campaign, .practice: navigation?.navigate(to: .levelSelect(mode: mode))
        case .challenge: navigation?.navigate(to: .modeSelect)
        case .sandbox: navigation?.navigate(to: .modeSelect)
        }
    }
    func setCanvasWidth(_ w: CGFloat) { canvasWidth = w }
}
