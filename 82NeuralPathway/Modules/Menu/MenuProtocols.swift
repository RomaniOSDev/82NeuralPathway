//
//  MenuProtocols.swift
//  82NeuralPathway
//

import SwiftUI

protocol MenuViewProtocol: AnyObject {}
protocol MenuInteractorProtocol { func prepareData() }
protocol MenuPresenterProtocol: ObservableObject {
    func onPlayTapped()
    func onEducationTapped()
    func onProgressionTapped()
    func onSettingsTapped()
}
protocol MenuRouterProtocol {
    func openLevelSelect()
    func openEducation()
    func openProgression()
    func openSettings()
}
