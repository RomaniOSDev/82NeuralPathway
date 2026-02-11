//
//  Level.swift
//  82NeuralPathway
//

import SwiftUI

struct TestCase: Codable {
    let inputs: [Double]
    let outputs: [Double]
}

struct Level: Identifiable {
    let id: Int
    let chapter: Int
    let title: String
    let description: String
    let problem: String
    let inputCount: Int
    let outputCount: Int
    let testCasesData: [TestCase]
    let maxNeurons: Int
    let maxConnections: Int
    let allowedNeuronTypes: [NeuronType]
    let optimalNeurons: Int?
    let optimalConnections: Int?
    let hint: String?

    var chapterTitle: String {
        ["Simple Reflexes", "Logical Operations", "Pattern Recognition", "Memory and State", "Complex Networks"][min(chapter - 1, 4)]
    }

}
