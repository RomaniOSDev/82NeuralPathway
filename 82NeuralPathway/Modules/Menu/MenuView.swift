//
//  MenuView.swift
//  82NeuralPathway
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var presenter: MenuPresenter
    @State private var pulseScale: CGFloat = 1
    @State private var glowOpacity: Double = 0.6
    var body: some View {
        ZStack {
            backgroundGradient
            neuralGlowOverlay
            VStack(spacing: 0) {
                Spacer()
                logoSection
                Spacer()
                actionsSection
            }
        }
    }
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                NeuralPathwayColors.background,
                NeuralPathwayColors.background.opacity(0.95),
                Color(hex: "0D1F2D")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    private var neuralGlowOverlay: some View {
        Canvas { context, size in
            for i in stride(from: 0, through: size.width, by: 60) {
                for j in stride(from: 0, through: size.height, by: 80) {
                    let rect = CGRect(x: i, y: j, width: 2, height: 2)
                    context.fill(Path(ellipseIn: rect), with: .color(NeuralPathwayColors.sensoryNeuron.opacity(0.15)))
                }
            }
        }
        .ignoresSafeArea()
    }
    private var logoSection: some View {
        VStack(spacing: 16) {
            Text("Neural Pathway")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, NeuralPathwayColors.sensoryNeuron.opacity(0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: NeuralPathwayColors.sensoryNeuron.opacity(0.4), radius: 12, x: 0, y: 4)
            Text("Connect. Think. Evolve.")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(NeuralPathwayColors.sensoryNeuron.opacity(0.9))
                .tracking(2)
            ZStack {
                Circle()
                    .fill(NeuralPathwayColors.sensoryNeuron.opacity(0.2))
                    .frame(width: 120, height: 120)
                    .scaleEffect(pulseScale)
                Circle()
                    .stroke(NeuralPathwayColors.motorNeuron.opacity(0.4), lineWidth: 2)
                    .frame(width: 100, height: 100)
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 44))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [NeuralPathwayColors.sensoryNeuron, NeuralPathwayColors.motorNeuron],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .padding(.top, 24)
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    pulseScale = 1.08
                }
            }
        }
    }
    private var actionsSection: some View {
        VStack(spacing: 20) {
            Button { presenter.onPlayTapped() } label: {
                HStack(spacing: 12) {
                    Image(systemName: "play.fill")
                        .font(.title3)
                    Text("Play")
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                }
                .foregroundColor(NeuralPathwayColors.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    LinearGradient(
                        colors: [NeuralPathwayColors.motorNeuron, NeuralPathwayColors.motorNeuron.opacity(0.85)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: NeuralPathwayColors.motorNeuron.opacity(0.5), radius: 16, x: 0, y: 6)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
            }
            .buttonStyle(ScaleButtonStyle())
            HStack(spacing: 14) {
                MenuButton(title: "Learn", icon: "book.fill", color: NeuralPathwayColors.sensoryNeuron) { presenter.onEducationTapped() }
                MenuButton(title: "Achievements", icon: "star.fill", color: NeuralPathwayColors.motorNeuron) { presenter.onProgressionTapped() }
                MenuButton(title: "Settings", icon: "gearshape.fill", color: .white.opacity(0.8)) { presenter.onSettingsTapped() }
            }
        }
        .padding(.horizontal, 36)
        .padding(.bottom, 48)
    }
}

struct MenuButton: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    init(title: String, icon: String, color: Color = NeuralPathwayColors.sensoryNeuron, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.color = color
        self.action = action
    }
    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(color)
                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.95))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.white.opacity(0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(color.opacity(0.4), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
