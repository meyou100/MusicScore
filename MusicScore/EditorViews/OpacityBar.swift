//
//  OpacityBar.swift
//  MusicScore
//
//  Created by Jonny Chang on 8/30/26.
//

import SwiftUI

struct OpacityBar: View {
    @Binding var preset: ToolPreset
    
    private var opacity: Binding<Double> {
        Binding(
            get: { (preset.opacity ?? 1) * 100 },
            set: { preset.opacity = $0 / 100 }
        )
    }
    
    @State private var opacityText: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Opacity")
                    .font(.subheadline)
                    .bold()
                
                Spacer()
                
                TextField("", text: $opacityText)
                    .frame(width: 60)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        if let value = Double(opacityText) {
                            opacity.wrappedValue = value
                        }
                    }
            }
            
            Slider(value: opacity, in: 1...100)
                .onChange(of: opacity.wrappedValue) { _, newValue in
                    opacityText = String(format: "%.0f%%", newValue)
                }
        }
        .onAppear {
            opacityText = String(format: "%.0f%%", opacity.wrappedValue)
        }
    }
}

#Preview {
    @Previewable @State var preset = ToolPreset.newDefault(for: .highlighter)
    
    OpacityBar(preset: Binding(
        get: { preset },
        set: { preset = $0 }
    ))
}
