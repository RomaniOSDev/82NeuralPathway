//
//  GameView.swift
//  82NeuralPathway
//

import SwiftUI

struct GameView: View {
    @ObservedObject var presenter: GamePresenter
    let levelId: Int
    let mode: GameMode
    var body: some View {
        ZStack {
            AppGradientBackground()
            VStack(spacing: 0) {
                topBar
                GeometryReader { geo in
                    GameCanvasView(presenter: presenter)
                        .onAppear {
                            presenter.setCanvasWidth(max(geo.size.width, 350))
                            presenter.configure(mode: mode)
                            if mode == .sandbox {
                                presenter.loadSandbox()
                            } else {
                                presenter.loadLevel(levelId)
                            }
                        }
                        .onChange(of: levelId) { if mode != .sandbox { presenter.loadLevel($0) } }
                }
                bottomBar
            }
        }
        .alert("Level Complete!", isPresented: $presenter.showLevelComplete) {
            Button("Next Level") { presenter.nextLevel() }
            Button("Stay") { presenter.showLevelComplete = false }
        } message: {
            Text("Stars: \(presenter.starsEarned)\nEfficiency: \(Int(presenter.efficiency))%")
        }
    }
    private var topBar: some View {
        HStack(spacing: 12) {
            Button { presenter.goBack() } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(ScaleButtonStyle())
            Spacer()
            if presenter.mode == .sandbox {
                Text("Sandbox")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(LinearGradient(colors: [.white, NeuralPathwayColors.motorNeuron.opacity(0.9)], startPoint: .leading, endPoint: .trailing))
                    .shadow(color: NeuralPathwayColors.motorNeuron.opacity(0.4), radius: 6, x: 0, y: 2)
            } else if presenter.mode == .challenge {
                Text("Daily Challenge")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(LinearGradient(colors: [NeuralPathwayColors.motorNeuron, NeuralPathwayColors.sensoryNeuron.opacity(0.9)], startPoint: .leading, endPoint: .trailing))
                    .shadow(color: NeuralPathwayColors.motorNeuron.opacity(0.5), radius: 8, x: 0, y: 2)
            }
            if presenter.canUndo {
                Button { presenter.undo() } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .buttonStyle(ScaleButtonStyle())
            }
            if let level = presenter.level {
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Level \(level.id)")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundStyle(LinearGradient(colors: [.white, NeuralPathwayColors.sensoryNeuron.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
                    Text("Neurons: \(presenter.network.neurons.count)/\(presenter.neuronLimit)")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                    Text("Connections: \(presenter.network.connections.count)/\(presenter.connectionLimit)")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
    }
    private var bottomBar: some View {
        VStack(spacing: 12) {
            if let level = presenter.level, presenter.mode != .sandbox {
                Text(level.problem).font(.caption).foregroundColor(.white.opacity(0.7)).multilineTextAlignment(.center).padding(.horizontal)
                if let hint = level.hint, presenter.showHint {
                    Text(hint).font(.caption2).foregroundColor(NeuralPathwayColors.sensoryNeuron).padding(.horizontal)
                }
            }
            HStack(spacing: 12) {
                ForEach(presenter.level?.allowedNeuronTypes ?? [.sensory, .motor], id: \.self) { type in
                    Button {
                        presenter.setPendingNeuronType(presenter.pendingNeuronType == type ? nil : type)
                    } label: {
                        NeuronTypeButton(type: type, isSelected: presenter.pendingNeuronType == type)
                    }
                    .disabled(presenter.network.neurons.count >= presenter.neuronLimit)
                }
            }
            if presenter.pendingNeuronType != nil {
                Text("Tap on canvas to place neuron").font(.caption2).foregroundColor(NeuralPathwayColors.sensoryNeuron)
            }
            HStack(spacing: 16) {
                if presenter.level?.hint != nil {
                    Button { presenter.toggleHint() } label: {
                        Image(systemName: "lightbulb.fill").foregroundColor(.white)
                    }
                }
                if presenter.mode != .sandbox {
                Button { presenter.runSimulation() } label: {
                    Text("Run")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(NeuralPathwayColors.background)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(LinearGradient(colors: [NeuralPathwayColors.motorNeuron, NeuralPathwayColors.motorNeuron.opacity(0.85)], startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .volumetricShadow(color: NeuralPathwayColors.motorNeuron.opacity(0.5), radius: 10, x: 0, y: 4)
                }
                .buttonStyle(ScaleButtonStyle())
                }
                Button { presenter.reset() } label: {
                    Text("Reset")
                        .font(.system(size: 17, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .padding(.horizontal, 28)
                        .padding(.vertical, 12)
                        .background(LinearGradient(colors: [Color.orange.opacity(0.9), Color.orange.opacity(0.7)], startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .volumetricShadow(color: .orange.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(ScaleButtonStyle())
                if presenter.selectedNeuronID != nil {
                    Button { presenter.removeSelectedNeuron() } label: {
                        Text("Delete")
                            .font(.system(size: 17, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(LinearGradient(colors: [Color.red.opacity(0.9), Color.red.opacity(0.7)], startPoint: .top, endPoint: .bottom))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .volumetricShadow(color: .red.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            if presenter.simulationState == .success {
                Text("Success!")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(LinearGradient(colors: [NeuralPathwayColors.motorNeuron, NeuralPathwayColors.sensoryNeuron.opacity(0.9)], startPoint: .leading, endPoint: .trailing))
                    .shadow(color: NeuralPathwayColors.motorNeuron.opacity(0.5), radius: 8, x: 0, y: 2)
            } else if presenter.simulationState == .failure {
                Text("Try again")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.red.opacity(0.9))
            }
        }
        .padding()
        .background(
            LinearGradient(
                colors: [NeuralPathwayColors.background.opacity(0.98), NeuralPathwayColors.background],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct NeuronTypeButton: View {
    let type: NeuronType
    let isSelected: Bool
    var body: some View {
        ZStack {
            switch type.shape {
            case .circle: Circle().fill(
                LinearGradient(colors: [type.color, type.color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
            ).frame(width: 40, height: 40)
            case .hexagon: Hexagon().fill(
                LinearGradient(colors: [type.color, type.color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
            ).frame(width: 40, height: 40)
            case .triangle: Triangle().fill(
                LinearGradient(colors: [type.color, type.color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
            ).frame(width: 40, height: 40)
            }
            Text(type.displayName.prefix(1))
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? Color.white : Color.clear, lineWidth: 3)
        )
        .volumetricShadow(color: type.color.opacity(isSelected ? 0.5 : 0.2), radius: 6, x: 0, y: 3)
    }
}
