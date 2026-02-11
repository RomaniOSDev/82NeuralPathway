//
//  ModeSelectView.swift
//  82NeuralPathway
//

import SwiftUI

struct ModeSelectView: View {
    @ObservedObject var presenter: ModeSelectPresenter
    @State private var appeared = false

    var body: some View {
        ZStack {
            AppGradientBackground()
            VStack(spacing: 0) {
                ScreenHeader(title: "Game Mode", onBack: { presenter.goBack() })
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(Array(presenter.modes.enumerated()), id: \.element.id) { index, mode in
                            ModeCard(mode: mode, delay: Double(index) * 0.08, appeared: appeared) {
                                presenter.selectMode(mode)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) { appeared = true }
        }
    }
}

struct ModeCard: View {
    let mode: GameMode
    let delay: Double
    let appeared: Bool
    let onTap: () -> Void
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 18) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [NeuralPathwayColors.sensoryNeuron.opacity(0.4), NeuralPathwayColors.motorNeuron.opacity(0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 56, height: 56)
                    Image(systemName: mode.iconName)
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [NeuralPathwayColors.sensoryNeuron, NeuralPathwayColors.motorNeuron.opacity(0.9)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .volumetricShadow(color: NeuralPathwayColors.sensoryNeuron, radius: 8, x: 0, y: 4)
                VStack(alignment: .leading, spacing: 6) {
                    Text(mode.title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    Text(mode.description)
                        .font(.system(size: 13, design: .rounded))
                        .foregroundColor(.white.opacity(0.75))
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "chevron.right.circle.fill")
                    .font(.title2)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [NeuralPathwayColors.sensoryNeuron.opacity(0.8), NeuralPathwayColors.motorNeuron.opacity(0.6)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            .padding(20)
            .background(
                LinearGradient(
                    colors: [Color.white.opacity(0.12), Color.white.opacity(0.06)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        LinearGradient(
                            colors: [NeuralPathwayColors.sensoryNeuron.opacity(0.4), Color.white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .volumetricShadow(color: .black.opacity(0.5), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(ScaleButtonStyle())
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay), value: appeared)
    }
}
