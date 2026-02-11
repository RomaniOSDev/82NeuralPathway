//
//  ContentView.swift
//  82NeuralPathway
//

import SwiftUI

struct ContentView: View {
    @StateObject private var navigation = AppAssembler.shared.navigation
    @State private var showOnboarding = !OnboardingService().hasCompletedOnboarding
    private let assembler = AppAssembler.shared

    var body: some View {
        ZStack {
            NeuralPathwayColors.background.ignoresSafeArea()
            switch navigation.currentRoute {
            case .menu:
                MenuView(presenter: assembler.menuPresenter)
            case .modeSelect:
                ModeSelectView(presenter: assembler.modeSelectPresenter)
            case .levelSelect(let mode):
                LevelSelectView(presenter: assembler.levelSelectPresenter, mode: mode)
            case .game(let levelId, let mode):
                GameView(presenter: assembler.gamePresenter, levelId: levelId, mode: mode)
            case .sandbox:
                GameView(presenter: assembler.gamePresenter, levelId: 0, mode: .sandbox)
            case .challenge(let levelId):
                GameView(presenter: assembler.gamePresenter, levelId: levelId, mode: .challenge)
            case .education:
                EducationView(presenter: assembler.educationPresenter)
            case .progression:
                ProgressionView(presenter: assembler.progressionPresenter)
            case .settings:
                SettingsView(presenter: assembler.settingsPresenter)
            }
        }
        .animation(.default, value: navigation.currentRoute)
        .preferredColorScheme(.dark)
        .fullScreenCover(isPresented: $showOnboarding) {
            OnboardingView {
                OnboardingService().completeOnboarding()
                showOnboarding = false
            }
        }
    }
}

#Preview {
    ContentView()
}
