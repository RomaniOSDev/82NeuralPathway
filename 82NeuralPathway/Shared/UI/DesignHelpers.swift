//
//  DesignHelpers.swift
//  82NeuralPathway
//

import SwiftUI

struct VolumetricShadow: ViewModifier {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    func body(content: Content) -> some View {
        content
            .shadow(color: color.opacity(0.4), radius: radius * 0.5, x: 0, y: 2)
            .shadow(color: color.opacity(0.3), radius: radius, x: x, y: y)
    }
}

struct CardGradientBackground: ViewModifier {
    let isActive: Bool
    func body(content: Content) -> some View {
        content
            .background(
                LinearGradient(
                    colors: [
                        Color.white.opacity(isActive ? 0.15 : 0.08),
                        Color.white.opacity(isActive ? 0.08 : 0.04)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        LinearGradient(
                            colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
    }
}

struct AppGradientBackground: View {
    var body: some View {
        LinearGradient(
            colors: [
                NeuralPathwayColors.background,
                NeuralPathwayColors.background.opacity(0.98),
                Color(hex: "0D1F2D")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct ScreenHeader: View {
    let title: String
    let onBack: () -> Void
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 44, height: 44)
                    .background(Color.white.opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(ScaleButtonStyle())
            Spacer()
            Text(title)
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, NeuralPathwayColors.sensoryNeuron.opacity(0.9)],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: NeuralPathwayColors.sensoryNeuron.opacity(0.3), radius: 8, x: 0, y: 2)
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension View {
    func volumetricShadow(color: Color = .black, radius: CGFloat = 12, x: CGFloat = 0, y: CGFloat = 6) -> some View {
        modifier(VolumetricShadow(color: color, radius: radius, x: x, y: y))
    }
    func cardGradient(isActive: Bool = false) -> some View {
        modifier(CardGradientBackground(isActive: isActive))
    }
}
