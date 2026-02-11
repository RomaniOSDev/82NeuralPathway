//
//  GameCanvasView.swift
//  82NeuralPathway
//

import SwiftUI

struct GameCanvasView: View {
    @ObservedObject var presenter: GamePresenter
    @State private var moveStartPosition: CGPoint?
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    var body: some View {
        GeometryReader { geo in
            ZStack {
                NeuralPathwayColors.background.ignoresSafeArea()
                backgroundGrid
                ZStack(alignment: .topLeading) {
                    ZStack(alignment: .topLeading) {
                    ForEach(presenter.network.connections) { conn in
                        if let from = presenter.network.neurons.first(where: { $0.id == conn.fromNeuronID }),
                           let to = presenter.network.neurons.first(where: { $0.id == conn.toNeuronID }) {
                            ConnectionView(connection: conn, fromPosition: from.position, toPosition: to.position, isActive: false)
                        }
                    }
                    if let drag = presenter.connectionInProgress,
                       let fromNeuron = presenter.network.neurons.first(where: { $0.id == drag.from }) {
                        DraggingConnectionView(from: fromNeuron.position, to: drag.position)
                    }
                    ForEach(presenter.network.neurons) { neuron in
                        NeuronView(neuron: neuron, isHighlighted: false, isSelected: presenter.selectedNeuronID == neuron.id,
                                  onTap: {
                            if presenter.connectionInProgress != nil, presenter.connectionInProgress?.from != neuron.id {
                                presenter.endConnection(at: neuron.position, on: neuron.id)
                            } else {
                                presenter.selectNeuron(presenter.selectedNeuronID == neuron.id ? nil : neuron.id)
                            }
                        }, onLongPress: { presenter.selectNeuron(neuron.id) })
                        .position(neuron.position)
                        .gesture(
                            DragGesture(minimumDistance: 8)
                                .onChanged { value in
                                    if presenter.selectedNeuronID == neuron.id {
                                        let start = moveStartPosition ?? neuron.position
                                        if moveStartPosition == nil { moveStartPosition = neuron.position }
                                        presenter.moveNeuron(id: neuron.id, to: CGPoint(x: start.x + value.translation.width, y: start.y + value.translation.height))
                                    } else if presenter.connectionInProgress == nil {
                                        presenter.startConnection(from: neuron.id, at: value.location)
                                    }
                                    if presenter.connectionInProgress != nil {
                                        presenter.updateConnectionDrag(value.location)
                                    }
                                }
                                .onEnded { value in
                                    moveStartPosition = nil
                                    if presenter.selectedNeuronID == neuron.id { return }
                                    let targetID = presenter.network.neurons.first { n in
                                        hypot(n.position.x - value.location.x, n.position.y - value.location.y) < 40 && n.id != neuron.id
                                    }?.id
                                    presenter.endConnection(at: value.location, on: targetID)
                                }
                        )
                    }
                    }
                    .scaleEffect(scale)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { scale = lastScale * $0 }
                            .onEnded { lastScale = min(2, max(0.5, lastScale * $0)); scale = lastScale }
                    )
                }
            }
        }
        .contentShape(Rectangle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onEnded { value in
                    if hypot(value.translation.width, value.translation.height) < 5, let type = presenter.pendingNeuronType {
                        presenter.addNeuron(type, at: value.startLocation)
                        presenter.setPendingNeuronType(nil)
                    }
                }
        )
        .gesture(DragGesture(minimumDistance: 20).onEnded { _ in presenter.cancelConnection() })
    }
    private var backgroundGrid: some View {
        Canvas { context, size in
            var path = Path()
            for x in stride(from: 0, through: size.width, by: 30) {
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
            for y in stride(from: 0, through: size.height, by: 30) {
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }
            context.stroke(path, with: .color(.white.opacity(0.06)), lineWidth: 1)
        }
        .ignoresSafeArea()
    }
}
