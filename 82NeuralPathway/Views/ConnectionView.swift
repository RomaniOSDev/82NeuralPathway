//
//  ConnectionView.swift
//  82NeuralPathway
//

import SwiftUI

struct ConnectionView: View {
    let connection: Connection
    let fromPosition: CGPoint
    let toPosition: CGPoint
    let isActive: Bool
    
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: fromPosition)
                path.addLine(to: toPosition)
            }
            .stroke(
                connection.connectionColor,
                style: StrokeStyle(
                    lineWidth: connection.visualWeight,
                    lineCap: .round,
                    lineJoin: .round,
                    dash: connection.delay > 0 ? [8, 6] : []
                )
            )
            
            if isActive {
                ConnectionPulseView(from: fromPosition, to: toPosition, color: connection.connectionColor)
            }
        }
    }
}

struct ConnectionPulseView: View {
    let from: CGPoint
    let to: CGPoint
    let color: Color
    
    @State private var progress: CGFloat = 0
    
    var body: some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }
        .trim(from: 0, to: progress)
        .stroke(color.opacity(0.9), lineWidth: 3)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: false)) {
                progress = 1
            }
        }
    }
}

struct DraggingConnectionView: View {
    let from: CGPoint
    let to: CGPoint
    
    var body: some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }
        .stroke(NeuralPathwayColors.sensoryNeuron.opacity(0.7), style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [6, 4]))
    }
}
