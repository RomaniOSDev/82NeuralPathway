//
//  LevelSelectView.swift
//  82NeuralPathway
//

import SwiftUI

struct LevelSelectView: View {
    @ObservedObject var presenter: LevelSelectPresenter
    let mode: GameMode
    @State private var appeared = false
    var body: some View {
        ZStack {
            AppGradientBackground()
            VStack(spacing: 0) {
                ScreenHeader(title: mode == .practice ? "Practice" : "Levels", onBack: { presenter.goBack() })
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 18) {
                        ForEach(Array(presenter.levels.enumerated()), id: \.element.id) { index, level in
                            LevelCell(
                                level: level,
                                isUnlocked: presenter.isUnlocked(level.id),
                                stars: presenter.stars(level.id),
                                delay: Double(index) * 0.03,
                                appeared: appeared
                            ) { presenter.selectLevel(level.id) }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            presenter.configure(mode: mode)
            presenter.load()
            withAnimation(.easeOut(duration: 0.4)) { appeared = true }
        }
    }
}

struct LevelCell: View {
    let level: Level
    let isUnlocked: Bool
    let stars: Int
    let delay: Double
    let appeared: Bool
    let onTap: () -> Void
    var body: some View {
        Button(action: { if isUnlocked { onTap() } }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: isUnlocked
                                    ? [NeuralPathwayColors.sensoryNeuron.opacity(0.6), NeuralPathwayColors.motorNeuron.opacity(0.3)]
                                    : [Color.gray.opacity(0.4), Color.gray.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                    if stars > 0 {
                        HStack(spacing: 3) {
                            ForEach(0..<min(stars, 3), id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(NeuralPathwayColors.motorNeuron)
                            }
                        }
                    } else {
                        Text("\(level.id)")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundColor(isUnlocked ? .white : .gray.opacity(0.7))
                    }
                }
                .volumetricShadow(color: isUnlocked ? NeuralPathwayColors.sensoryNeuron : .clear, radius: 8, x: 0, y: 4)
                Text("\(level.id)")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(isUnlocked ? 0.9 : 0.5))
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .opacity(isUnlocked ? 1 : 0.6)
        .disabled(!isUnlocked)
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.8)
        .animation(.spring(response: 0.4, dampingFraction: 0.7).delay(delay), value: appeared)
    }
}
