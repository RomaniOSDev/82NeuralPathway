//
//  AppAssembler.swift
//  82NeuralPathway
//

import SwiftUI

@MainActor
final class AppAssembler {
    static let shared = AppAssembler()
    let navigation = AppNavigation()
    private let persistence = PersistenceService()
    private lazy var progression: ProgressionService = ProgressionService(persistence: persistence)
    private let levelService = LevelDataService()
    private let undoService = UndoService()
    private let educationService = EducationService()
    private let achievementService = AchievementService()
    
    lazy var modeSelectPresenter: ModeSelectPresenter = {
        ModeSelectPresenter(navigation: navigation)
    }()

    lazy var menuPresenter: MenuPresenter = {
        let router = MenuRouter()
        router.navigation = navigation
        return MenuPresenter(interactor: MenuInteractor(), router: router)
    }()
    
    lazy var levelSelectPresenter: LevelSelectPresenter = {
        LevelSelectPresenter(interactor: LevelSelectInteractor(levelService: levelService, progression: progression), navigation: navigation)
    }()
    
    lazy var gamePresenter: GamePresenter = {
        GamePresenter(interactor: GameInteractor(levelService: levelService, progression: progression, undoService: undoService), navigation: navigation)
    }()
    
    lazy var educationPresenter: EducationPresenter = {
        EducationPresenter(interactor: EducationInteractor(), navigation: navigation)
    }()
    
    lazy var progressionPresenter: ProgressionPresenter = {
        ProgressionPresenter(interactor: ProgressionInteractor(achievementService: achievementService, progression: progression), navigation: navigation)
    }()
    
    lazy var settingsPresenter: SettingsPresenter = {
        SettingsPresenter(interactor: SettingsInteractor(persistence: persistence), navigation: navigation)
    }()
    
    private init() {}
}
