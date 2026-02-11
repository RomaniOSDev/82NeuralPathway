//
//  MenuPresenter.swift
//  82NeuralPathway
//

import SwiftUI
import Combine

@MainActor
final class MenuPresenter: MenuPresenterProtocol, ObservableObject {
    private let interactor: MenuInteractorProtocol
    private let router: MenuRouterProtocol
    init(interactor: MenuInteractorProtocol, router: MenuRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    func onPlayTapped() { router.openLevelSelect() }
    func onEducationTapped() { router.openEducation() }
    func onProgressionTapped() { router.openProgression() }
    func onSettingsTapped() { router.openSettings() }
}
