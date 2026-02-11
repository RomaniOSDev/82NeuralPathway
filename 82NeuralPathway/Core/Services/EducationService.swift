//
//  EducationService.swift
//  82NeuralPathway
//

import Foundation

struct LevelTip: Identifiable {
    let id: Int
    let levelId: Int?
    let title: String
    let text: String
}

protocol EducationServiceProtocol {
    func tips(forChapter chapter: Int) -> [LevelTip]
    func brainFacts() -> [BrainFact]
    func tipForLevel(_ levelId: Int) -> LevelTip?
}

final class EducationService: EducationServiceProtocol {
    func tips(forChapter chapter: Int) -> [LevelTip] {
        switch chapter {
        case 1: return [
            LevelTip(id: 1, levelId: nil, title: " inhibitory connection", text: "An inhibitory connection reduces the activity of the next neuron. Use negative weight."),
            LevelTip(id: 2, levelId: nil, title: "Feedback", text: "Feedback creates memory: output can influence future inputs.")
        ]
        case 2: return [
            LevelTip(id: 3, levelId: nil, title: "AND logic", text: "AND: output ON only when ALL inputs are ON. Use an intermediate neuron with high threshold."),
            LevelTip(id: 4, levelId: nil, title: "OR logic", text: "OR: output ON when ANY input is ON. Connect inputs to the same target.")
        ]
        default: return []
        }
    }
    func brainFacts() -> [BrainFact] {
        [
            BrainFact(id: "1", text: "The human brain has about 86 billion neurons.", category: .neurons),
            BrainFact(id: "2", text: "Synaptic transmission takes about 1 millisecond.", category: .synapses),
            BrainFact(id: "3", text: "Neuroplasticity allows the brain to rewire itself.", category: .plasticity),
            BrainFact(id: "4", text: "Your network works like Rosenblatt's perceptron.", category: .ml)
        ]
    }
    func tipForLevel(_ levelId: Int) -> LevelTip? {
        switch levelId {
        case 1: return LevelTip(id: 101, levelId: 1, title: "First step", text: "Drag from the blue sensory neuron to the green motor neuron to create a connection.")
        case 2: return LevelTip(id: 102, levelId: 2, title: "Reflex", text: "A direct connection creates a simple reflex: input → output.")
        case 3: return LevelTip(id: 103, levelId: 3, title: "AND", text: "Add an intermediate (gray) neuron. Connect both inputs to it, and it to the output. Both must be ON.")
        case 4: return LevelTip(id: 104, levelId: 4, title: "OR", text: "Connect each input directly to the output. Either one activates it.")
        default: return nil
        }
    }
}
