//
//  UndoService.swift
//  82NeuralPathway
//

import Foundation
import Combine

struct NetworkSnapshot {
    let neurons: [Neuron]
    let connections: [Connection]
    let inputs: [UUID]
    let outputs: [UUID]
}

protocol UndoServiceProtocol {
    var canUndo: Bool { get }
    func push(_ snapshot: NetworkSnapshot)
    func pop() -> NetworkSnapshot?
    func clear()
}

final class UndoService: UndoServiceProtocol {
    private var stack: [NetworkSnapshot] = []
    private let maxSize = 20
    var canUndo: Bool { !stack.isEmpty }
    func push(_ snapshot: NetworkSnapshot) {
        stack.append(snapshot)
        if stack.count > maxSize { stack.removeFirst() }
    }
    func pop() -> NetworkSnapshot? { stack.popLast() }
    func clear() { stack.removeAll() }
}
