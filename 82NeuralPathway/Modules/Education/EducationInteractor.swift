//
//  EducationInteractor.swift
//  82NeuralPathway
//

import Foundation

protocol EducationInteractorProtocol {
    func loadTips(forChapter chapter: Int) -> [LevelTip]
    func loadBrainFacts() -> [BrainFact]
}

final class EducationInteractor: EducationInteractorProtocol {
    private let service: EducationServiceProtocol = EducationService()
    func loadTips(forChapter chapter: Int) -> [LevelTip] { service.tips(forChapter: chapter) }
    func loadBrainFacts() -> [BrainFact] { service.brainFacts() }
}
