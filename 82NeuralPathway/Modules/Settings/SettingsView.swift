//
//  SettingsView.swift
//  82NeuralPathway
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var presenter: SettingsPresenter
    @State private var appeared = false
    var body: some View {
        ZStack {
            AppGradientBackground()
            VStack(spacing: 0) {
                ScreenHeader(title: "Settings", onBack: { presenter.goBack() })
                ScrollView {
                VStack(spacing: 16) {
                    SettingsLinkRow(title: "Rate Us", icon: "star.fill", color: NeuralPathwayColors.motorNeuron) { presenter.rateApp() }
                    SettingsLinkRow(title: "Privacy Policy", icon: "hand.raised.fill", color: NeuralPathwayColors.sensoryNeuron) { presenter.openPrivacy() }
                    SettingsLinkRow(title: "Terms of Service", icon: "doc.text.fill", color: NeuralPathwayColors.sensoryNeuron) { presenter.openTerms() }
                    Button { presenter.requestReset() } label: {
                        HStack {
                            Image(systemName: "arrow.counterclockwise.circle.fill")
                                .font(.title2)
                                .foregroundStyle(LinearGradient(colors: [.red.opacity(0.9), .orange.opacity(0.7)], startPoint: .topLeading, endPoint: .bottomTrailing))
                            Text("Reset progress")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(20)
                        .background(LinearGradient(colors: [Color.red.opacity(0.2), Color.red.opacity(0.08)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.red.opacity(0.4), lineWidth: 1))
                        .volumetricShadow(color: .red.opacity(0.3), radius: 10, x: 0, y: 4)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                }
                .padding()
                .opacity(appeared ? 1 : 0)
                .offset(y: appeared ? 0 : 20)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: appeared)
            }
        }
        .onAppear {
            presenter.load()
            withAnimation(.easeOut(duration: 0.4)) { appeared = true }
        }
        .alert("Reset progress?", isPresented: $presenter.showResetAlert) {
            Button("Cancel", role: .cancel) {}
            Button("Reset", role: .destructive) { presenter.resetProgress() }
        } message: {
            Text("All levels and achievements will be reset.")
        }
    }
}

struct SettingsLinkRow: View {
    let title: String
    let icon: String
    let color: Color
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundStyle(LinearGradient(colors: [color, color.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
                Text(title)
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(20)
            .background(LinearGradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(color.opacity(0.3), lineWidth: 1))
            .volumetricShadow(color: color.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
