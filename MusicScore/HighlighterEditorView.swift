//
//  HighlighterEditorView.swift
//  MusicScore
//
//  Created by Jonny C on 8/3/26.
//

import SwiftUI

struct HighlighterEditorView: View {
    @Binding var preset: ToolPreset
    var remove: () -> Void
    
    private var width: Binding<CGFloat> {
        Binding(
            get: { preset.width ?? 5 },
            set: { preset.width = $0 }
        )
    }
    
    private var color: Binding<Color> {
        Binding(
            get: { preset.color ?? .black },
            set: { preset.color = $0 }
        )
    }
    
    private var opacity: Binding<Double> {
        Binding(
            get: { (preset.opacity ?? 1) * 100 },
            set: { preset.opacity = $0 / 100 }
        )
    }
    
    @State private var widthText: String = ""
    @State private var showCustomColorPicker = false
    @State private var opacityText: String = ""
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button {
                    preset.reset()
                } label: {
                    Text("Reset")
                }
                
                Spacer()
                
                Text("Highlighter")
                    .font(.headline)
                
                Spacer()
                
                Button(role: .destructive) {
                    remove()
                } label: {
                    Text("Remove")
                }
            }
            
            Divider()
                .padding(.vertical, 5)
            
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
            
            HStack {
                Text("Color")
                    .font(.subheadline)
                    .bold()
                
                Spacer()
                
                ColorPicker("", selection: color)
                    .labelsHidden()
                    .frame(width: 28, height: 28)
            }
            
            ForEach(0..<2, id: \.self) { i in
                HStack(spacing: 10) {
                    ForEach(i * 7..<i * 7 + 7, id: \.self) { j in
                        Button {
                            color.wrappedValue = Constants.commonColors[j]
                        } label: {
                            Circle()
                                .fill(Constants.commonColors[j])
                                .frame(width: 28, height: 28)
                                .overlay(
                                    ZStack {
                                        Circle()
                                            .stroke(Color.gray, lineWidth: 1)
                                        
                                        Circle()
                                            .stroke(selectedRingColor(for: color.wrappedValue), lineWidth: 2)
                                            .opacity(color.wrappedValue == Constants.commonColors[j] ? 1 : 0)
                                            .frame(width: 20, height: 20)
                                    }
                                )
                        }
                    }
                }
            }
        }
        .padding()
        .frame(width: 300)
        .onAppear {
            widthText = String(format: "%.0f", width.wrappedValue)
            opacityText = String(format: "%.0f%%", opacity.wrappedValue)
        }
    }
    
    private func selectedRingColor(for swatch: Color) -> Color {
        return swatch == .white ? .gray : .white
    }
}

#Preview {
    @Previewable @State var preset = ToolPreset.newDefault(for: .highlighter)
    
    HighlighterEditorView(preset: Binding(
        get: { preset },
        set: { preset = $0 }
    ),
                          remove: {})
}
