//
//  EducationView.swift
//  82NeuralPathway
//

import SwiftUI

struct EducationView: View {
    @ObservedObject var presenter: EducationPresenter
    @State private var appeared = false
    var body: some View {
        ZStack {
            AppGradientBackground()
            VStack(spacing: 0) {
                ScreenHeader(title: "Learn", onBack: { presenter.goBack() })
                Picker("Chapter", selection: $presenter.selectedChapter) {
                    ForEach(1...5, id: \.self) { Text("Ch \($0)").tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .onChange(of: presenter.selectedChapter) { newVal in presenter.setChapter(newVal) }
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        if !presenter.tips.isEmpty {
                            Text("Tips")
                                .font(.system(size: 20, weight: .bold, design: .rounded))
                                .foregroundStyle(LinearGradient(colors: [.white, NeuralPathwayColors.sensoryNeuron.opacity(0.9)], startPoint: .leading, endPoint: .trailing))
                                .shadow(color: NeuralPathwayColors.sensoryNeuron.opacity(0.3), radius: 6, x: 0, y: 2)
                            ForEach(Array(presenter.tips.enumerated()), id: \.element.id) { index, tip in
                                EducationTipCard(tip: tip, delay: Double(index) * 0.06, appeared: appeared)
                            }
                        }
                        Text("Brain Facts")
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                            .foregroundStyle(LinearGradient(colors: [.white, NeuralPathwayColors.motorNeuron.opacity(0.9)], startPoint: .leading, endPoint: .trailing))
                            .shadow(color: NeuralPathwayColors.motorNeuron.opacity(0.3), radius: 6, x: 0, y: 2)
                        ForEach(Array(presenter.brainFacts.enumerated()), id: \.element.id) { index, fact in
                            BrainFactCard(fact: fact, delay: Double(index) * 0.05, appeared: appeared)
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

struct EducationTipCard: View {
    let tip: LevelTip
    let delay: Double
    let appeared: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(tip.title)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .foregroundStyle(LinearGradient(colors: [NeuralPathwayColors.sensoryNeuron, NeuralPathwayColors.motorNeuron.opacity(0.8)], startPoint: .leading, endPoint: .trailing))
            Text(tip.text)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [Color.white.opacity(0.12), Color.white.opacity(0.06)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(NeuralPathwayColors.sensoryNeuron.opacity(0.3), lineWidth: 1))
        .volumetricShadow(color: NeuralPathwayColors.sensoryNeuron.opacity(0.3), radius: 10, x: 0, y: 4)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 15)
        .animation(.spring(response: 0.45, dampingFraction: 0.8).delay(delay), value: appeared)
    }
}

struct BrainFactCard: View {
    let fact: BrainFact
    let delay: Double
    let appeared: Bool
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 28))
                .foregroundStyle(LinearGradient(colors: [NeuralPathwayColors.motorNeuron, NeuralPathwayColors.sensoryNeuron.opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
            Text(fact.text)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [Color.white.opacity(0.08), Color.white.opacity(0.04)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .overlay(RoundedRectangle(cornerRadius: 14).stroke(NeuralPathwayColors.motorNeuron.opacity(0.2), lineWidth: 1))
        .volumetricShadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)
        .opacity(appeared ? 1 : 0)
        .offset(x: appeared ? 0 : -20)
        .animation(.spring(response: 0.4, dampingFraction: 0.8).delay(delay), value: appeared)
    }
}
