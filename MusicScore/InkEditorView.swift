//
//  InkEditorView.swift
//  MusicScore
//
//  Created by Jonny C on 8/3/26.
//

import SwiftUI

struct InkEditorView: View {
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
    
    @State private var widthText: String = ""
    @State private var showCustomColorPicker = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button {
                    preset.reset()
                } label: {
                    Text("Reset")
                }
                
                Spacer()
                
                Text("Pen")
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
        }
    }
    
    private func selectedRingColor(for swatch: Color) -> Color {
        return swatch == .white ? .gray : .white
    }
}


#Preview {
    @Previewable @State var preset = ToolPreset.newDefault(for: .ink)
    
    InkEditorView(preset: Binding(
        get: { preset },
        set: { preset = $0 }
    ),
                  remove: {})
}
