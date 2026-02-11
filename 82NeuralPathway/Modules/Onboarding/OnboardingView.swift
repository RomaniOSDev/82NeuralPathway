//
//  OnboardingView.swift
//  82NeuralPathway
//

import SwiftUI

struct OnboardingPage: Identifiable {
    let id: Int
    let title: String
    let description: String
    let iconName: String
}

struct OnboardingView: View {
    let onComplete: () -> Void
    @State private var currentPage = 0
    private let pages: [OnboardingPage] = [
        OnboardingPage(id: 0, title: "Design Neural Networks", description: "Connect sensory and motor neurons to build intelligent networks. Drag to create connections.", iconName: "point.3.connected.trianglepath.dotted"),
        OnboardingPage(id: 1, title: "Solve Challenges", description: "Complete levels by designing networks that pass all test cases. Earn stars for optimization.", iconName: "star.circle.fill"),
        OnboardingPage(id: 2, title: "Connect. Think. Evolve.", description: "Learn how neural networks work through interactive gameplay. Start your journey now.", iconName: "brain.head.profile")
    ]

    var body: some View {
        ZStack {
            AppGradientBackground()
            VStack(spacing: 0) {
                TabView(selection: $currentPage) {
                    ForEach(pages) { page in
                        OnboardingPageView(page: page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                PageControl(numberOfPages: pages.count, currentPage: currentPage)
                    .padding(.vertical, 24)
                Button {
                    if currentPage < pages.count - 1 {
                        withAnimation { currentPage += 1 }
                    } else {
                        onComplete()
                    }
                } label: {
                    Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(NeuralPathwayColors.background)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(LinearGradient(colors: [NeuralPathwayColors.motorNeuron, NeuralPathwayColors.motorNeuron.opacity(0.9)], startPoint: .top, endPoint: .bottom))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .volumetricShadow(color: NeuralPathwayColors.motorNeuron.opacity(0.5), radius: 12, x: 0, y: 6)
                }
                .buttonStyle(ScaleButtonStyle())
                .padding(.horizontal, 40)
                .padding(.bottom, 48)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            ZStack {
                Circle()
                    .fill(NeuralPathwayColors.sensoryNeuron.opacity(0.2))
                    .frame(width: 160, height: 160)
                Image(systemName: page.iconName)
                    .font(.system(size: 72))
                    .foregroundStyle(LinearGradient(colors: [NeuralPathwayColors.sensoryNeuron, NeuralPathwayColors.motorNeuron], startPoint: .topLeading, endPoint: .bottomTrailing))
            }
            .volumetricShadow(color: NeuralPathwayColors.sensoryNeuron.opacity(0.3), radius: 20, x: 0, y: 10)
            VStack(spacing: 16) {
                Text(page.title)
                    .font(.system(size: 26, weight: .bold, design: .rounded))
                    .foregroundStyle(LinearGradient(colors: [.white, NeuralPathwayColors.sensoryNeuron.opacity(0.9)], startPoint: .leading, endPoint: .trailing))
                    .multilineTextAlignment(.center)
                    .shadow(color: NeuralPathwayColors.sensoryNeuron.opacity(0.3), radius: 8, x: 0, y: 2)
                Text(page.description)
                    .font(.system(size: 16, design: .rounded))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            Spacer()
        }
    }
}

struct PageControl: View {
    let numberOfPages: Int
    let currentPage: Int
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? NeuralPathwayColors.motorNeuron : Color.white.opacity(0.4))
                    .frame(width: index == currentPage ? 12 : 8, height: index == currentPage ? 12 : 8)
                    .animation(.easeInOut(duration: 0.2), value: currentPage)
            }
        }
    }
}
