//
//  BrainFact.swift
//  82NeuralPathway
//

import Foundation

struct BrainFact: Identifiable {
    let id: String
    let text: String
    let category: BrainFactCategory
}

enum BrainFactCategory: String {
    case neurons, synapses, plasticity, ml
}
