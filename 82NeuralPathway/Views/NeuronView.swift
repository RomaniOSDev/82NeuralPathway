//
//  NeuronView.swift
//  82NeuralPathway
//

import SwiftUI
import Combine

struct NeuronView: View {
    let neuron: Neuron
    let isHighlighted: Bool
    let isSelected: Bool
    let onTap: () -> Void
    let onLongPress: () -> Void
    
    init(
        neuron: Neuron,
        isHighlighted: Bool = false,
        isSelected: Bool = false,
        onTap: @escaping () -> Void = {},
        onLongPress: @escaping () -> Void = {}
    ) {
        self.neuron = neuron
        self.isHighlighted = isHighlighted
        self.isSelected = isSelected
        self.onTap = onTap
        self.onLongPress = onLongPress
    }
    
    private var neuronShape: NeuronShapeAdaptor {
        NeuronShapeAdaptor(shapeKind: neuron.type.shape)
    }
    
    var body: some View {
        ZStack {
            neuronShape
                .fill(neuron.type.color)
                .frame(width: 50, height: 50)
            
            neuronShape
                .stroke(neuron.type.color.opacity(0.8), lineWidth: 2)
                .frame(width: 50, height: 50)
            
            if neuron.isActive {
                neuronShape
                    .stroke(neuron.type.color, lineWidth: 4)
                    .frame(width: 65, height: 65)
                    .scaleEffect(isHighlighted ? 1.15 : 1)
                    .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isHighlighted)
            }
            
            if isSelected {
                neuronShape
                    .stroke(Color.white, lineWidth: 3)
                    .frame(width: 58, height: 58)
            }
            
            Circle()
                .fill(Color.white.opacity(neuron.activation * 0.6))
                .frame(width: 20, height: 20)
        }
        .onTapGesture { onTap() }
        .onLongPressGesture { onLongPress() }
    }
}
