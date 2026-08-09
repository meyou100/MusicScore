//
//  EraserEditorView.swift
//  MusicScore
//
//  Created by Jonny C on 8/3/26.
//

import SwiftUI
import PencilKit

struct EraserEditorView: View {
    @Binding var preset: ToolPreset
    var remove: () -> Void
    
    @State private var widthText: String = ""
    
    private var width: Binding<CGFloat> {
        Binding(
            get: { preset.width ?? 5 },
            set: { preset.width = $0 }
        )
    }
    
    private var eraserType: Binding<PKEraserTool.EraserType> {
        Binding(
            get: { preset.eraserType ?? .bitmap },
            set: { preset.eraserType = $0 }
        )
    }

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button {
                    preset.reset()
                } label: {
                    Text("Reset")
                }
                
                Spacer()
                
                Text("Eraser")
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
                Text("Eraser Width")
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
            
            Text("Eraser Type")
                .font(.subheadline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                Button {
                    eraserType.wrappedValue = .bitmap
                } label: {
                    Text("Pixel")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(eraserType.wrappedValue == .bitmap ? Color.accentColor : Color.gray.opacity(0.2))
                        .foregroundStyle(eraserType.wrappedValue == .bitmap ? .white : .primary)
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                Button {
                    eraserType.wrappedValue = .vector
                } label: {
                    Text("Object")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(eraserType.wrappedValue == .vector ? Color.accentColor : Color.gray.opacity(0.2))
                        .foregroundStyle(eraserType.wrappedValue == .vector ? .white : .primary)
                        .clipShape(Capsule())
                }
            }
            
            Text("Eraser Layer")
                .font(.subheadline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                
            
            HStack {
                Button {
                    preset.editingWhiteout = false
                } label: {
                    Text("Normal")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(!preset.editingWhiteout ? Color.accentColor : Color.gray.opacity(0.2))
                        .foregroundStyle(!preset.editingWhiteout ? .white : .primary)
                        .clipShape(Capsule())
                }
                
                Spacer()
                
                Button {
                    preset.editingWhiteout = true
                } label: {
                    Text("Whiteout")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(preset.editingWhiteout ? Color.accentColor : Color.gray.opacity(0.2))
                        .foregroundStyle(preset.editingWhiteout ? .white : .primary)
                        .clipShape(Capsule())
                }
            }
        }
        .padding()
        .frame(width: 300)
        .onAppear {
            widthText = String(format: "%.0f", width.wrappedValue)
        }
    }
}



#Preview {
    @Previewable @State var preset = ToolPreset.newDefault(for: .eraser)
    
    EraserEditorView(preset: Binding(
        get: { preset },
        set: { preset = $0 }
    ),
                     remove: {}
    )
}
