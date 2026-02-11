//
//  ProgressionView.swift
//  82NeuralPathway
//

import SwiftUI

struct ProgressionView: View {
    @ObservedObject var presenter: ProgressionPresenter
    @State private var appeared = false
    var body: some View {
        ZStack {
            AppGradientBackground()
            VStack(spacing: 0) {
                ScreenHeader(title: "Achievements", onBack: { presenter.goBack() })
                VStack(spacing: 14) {
                    HStack(spacing: 14) {
                        StatBadge(value: "\(presenter.completedLevels)", label: "Levels")
                        StatBadge(value: "\(presenter.totalStars)", label: "Stars")
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
                ScrollView {
                    LazyVStack(spacing: 14) {
                        ForEach(Array(presenter.achievements.enumerated()), id: \.element.id) { index, a in
                            AchievementRow(achievement: a.definition, isUnlocked: a.isUnlocked, delay: Double(index) * 0.05, appeared: appeared)
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            presenter.load()
            withAnimation(.easeOut(duration: 0.4)) { appeared = true }
        }
    }
}

struct StatBadge: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 6) {
            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(LinearGradient(colors: [NeuralPathwayColors.motorNeuron, NeuralPathwayColors.sensoryNeuron.opacity(0.9)], startPoint: .top, endPoint: .bottom))
                .shadow(color: NeuralPathwayColors.motorNeuron.opacity(0.5), radius: 8, x: 0, y: 2)
            Text(label)
                .font(.system(size: 13, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.85))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(LinearGradient(colors: [Color.white.opacity(0.14), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(NeuralPathwayColors.motorNeuron.opacity(0.4), lineWidth: 1))
        .volumetricShadow(color: NeuralPathwayColors.motorNeuron.opacity(0.3), radius: 12, x: 0, y: 6)
    }
}

struct AchievementRow: View {
    let achievement: AchievementDefinition
    let isUnlocked: Bool
    let delay: Double
    let appeared: Bool
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(LinearGradient(colors: isUnlocked ? [NeuralPathwayColors.motorNeuron.opacity(0.4), NeuralPathwayColors.sensoryNeuron.opacity(0.2)] : [Color.gray.opacity(0.3), Color.gray.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 48, height: 48)
                Image(systemName: achievement.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(isUnlocked ? NeuralPathwayColors.motorNeuron : .gray.opacity(0.7))
            }
            .volumetricShadow(color: isUnlocked ? NeuralPathwayColors.motorNeuron.opacity(0.3) : .clear, radius: 6, x: 0, y: 3)
            VStack(alignment: .leading, spacing: 4) {
                Text(achievement.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .foregroundColor(isUnlocked ? .white : .gray.opacity(0.8))
                Text(achievement.description)
                    .font(.system(size: 13, design: .rounded))
                    .foregroundColor(.white.opacity(isUnlocked ? 0.8 : 0.5))
            }
            Spacer()
            if isUnlocked {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(LinearGradient(colors: [NeuralPathwayColors.motorNeuron, NeuralPathwayColors.sensoryNeuron.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
        }
        .padding(18)
        .background(LinearGradient(colors: [Color.white.opacity(isUnlocked ? 0.14 : 0.06), Color.white.opacity(isUnlocked ? 0.08 : 0.03)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(isUnlocked ? NeuralPathwayColors.motorNeuron.opacity(0.35) : Color.white.opacity(0.08), lineWidth: 1))
        .volumetricShadow(color: .black.opacity(isUnlocked ? 0.4 : 0.2), radius: 10, x: 0, y: 4)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 20)
        .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(delay), value: appeared)
    }
}
