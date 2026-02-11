//
//  EducationPresenter.swift
//  82NeuralPathway
//

import SwiftUI
import Combine

@MainActor
final class EducationPresenter: ObservableObject {
    @Published var tips: [LevelTip] = []
    @Published var brainFacts: [BrainFact] = []
    @Published var selectedChapter = 1
    private let interactor: EducationInteractorProtocol
    private weak var navigation: AppNavigationProtocol?
    init(interactor: EducationInteractorProtocol, navigation: AppNavigationProtocol?) {
        self.interactor = interactor
        self.navigation = navigation
    }
    func load() {
        tips = interactor.loadTips(forChapter: selectedChapter)
        brainFacts = interactor.loadBrainFacts()
    }
    func setChapter(_ c: Int) {
        selectedChapter = c
        tips = interactor.loadTips(forChapter: c)
    }
    func goBack() { navigation?.navigate(to: .menu) }
}
