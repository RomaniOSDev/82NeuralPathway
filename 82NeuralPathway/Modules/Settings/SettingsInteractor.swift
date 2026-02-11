//
//  SettingsInteractor.swift
//  82NeuralPathway
//

import Foundation

protocol SettingsInteractorProtocol {
    func isDarkTheme() -> Bool
    func setDarkTheme(_ value: Bool)
    func resetProgress()
}

final class SettingsInteractor: SettingsInteractorProtocol {
    private let persistence: PersistenceServiceProtocol
    private let themeKey = "darkTheme"
    init(persistence: PersistenceServiceProtocol = PersistenceService()) {
        self.persistence = persistence
    }
    func isDarkTheme() -> Bool {
        (persistence.load(Bool.self, forKey: themeKey) ?? true)
    }
    func setDarkTheme(_ value: Bool) {
        persistence.save(value, forKey: themeKey)
    }
    func resetProgress() {
        persistence.remove(forKey: "progression")
        persistence.remove(forKey: "achievements")
    }
}
