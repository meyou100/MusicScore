//
//  StrokeWidthBar.swift
//  MusicScore
//
//  Created by Jonny Chang on 8/30/26.
//

import SwiftUI

struct StrokeWidthBar: View {
    @Binding var preset: ToolPreset
    
    private var width: Binding<CGFloat> {
        Binding(
            get: { preset.width ?? 5 },
            set: { preset.width = $0 }
        )
    }
    
    @State private var widthText: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("Stroke Width")
                    .font(.subheadline)
                    .bold()
                
                Spacer()
                
                TextField("", text: $widthText)
                    .frame(width: 40)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        if let value = Double(widthText) {
                            width.wrappedValue = CGFloat(value)
                        }
                    }
            }
            
            Slider(value: width, in: 1...30)
                .onChange(of: width.wrappedValue) { _, newValue in
                    widthText = String(format: "%.0f", newValue)
                }
        }
        .onAppear {
            widthText = String(format: "%.0f", width.wrappedValue)
        }
    }
}

#Preview {
    @Previewable @State var preset = ToolPreset.newDefault(for: .highlighter)
    StrokeWidthBar(preset: Binding (
        get: {preset },
        set: {preset = $0}
    ))
}
