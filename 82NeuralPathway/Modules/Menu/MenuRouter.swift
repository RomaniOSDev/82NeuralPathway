//
//  MenuRouter.swift
//  82NeuralPathway
//

import SwiftUI

final class MenuRouter: MenuRouterProtocol {
    weak var navigation: AppNavigationProtocol?
    func openLevelSelect() { navigation?.navigate(to: .modeSelect) }
    func openEducation() { navigation?.navigate(to: .education) }
    func openProgression() { navigation?.navigate(to: .progression) }
    func openSettings() { navigation?.navigate(to: .settings) }
}
