//
//  SettingsPresenter.swift
//  82NeuralPathway
//

import SwiftUI
import Combine

@MainActor
final class SettingsPresenter: ObservableObject {
    @Published var isDarkTheme: Bool = true
    @Published var showResetAlert = false
    private let interactor: SettingsInteractorProtocol
    private weak var navigation: AppNavigationProtocol?
    init(interactor: SettingsInteractorProtocol, navigation: AppNavigationProtocol?) {
        self.interactor = interactor
        self.navigation = navigation
    }
    func load() { isDarkTheme = interactor.isDarkTheme() }
    func setTheme(_ value: Bool) {
        isDarkTheme = value
        interactor.setDarkTheme(value)
    }
    func requestReset() { showResetAlert = true }
    func resetProgress() {
        interactor.resetProgress()
        showResetAlert = false
    }
    func goBack() { navigation?.navigate(to: .menu) }
    func openPrivacy() { AppLinks.openPrivacy() }
    func openTerms() { AppLinks.openTerms() }
    func rateApp() { AppLinks.rateApp() }
}
