//
//  AppNavigation.swift
//  82NeuralPathway
//

import SwiftUI
import Combine

enum AppRoute: Equatable {
    case menu
    case modeSelect
    case levelSelect(mode: GameMode)
    case game(levelId: Int, mode: GameMode)
    case sandbox
    case challenge(levelId: Int)
    case education
    case progression
    case settings
}

protocol AppNavigationProtocol: AnyObject {
    func navigate(to route: AppRoute)
}

@MainActor
final class AppNavigation: ObservableObject, AppNavigationProtocol {
    @Published var currentRoute: AppRoute = .menu
    func navigate(to route: AppRoute) { currentRoute = route }
}
