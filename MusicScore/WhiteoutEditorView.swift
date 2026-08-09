//
//  WhiteoutEditorView.swift
//  MusicScore
//
//  Created by Jonny C on 8/3/26.
//

import SwiftUI

struct WhiteoutEditorView: View {
    @Binding var preset: ToolPreset
    var remove: () -> Void
    @State private var widthText: String = ""
    
    private var width: Binding<CGFloat> {
        Binding(
            get: { preset.width ?? 5 },
            set: { preset.width = $0 }
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
                
                Text("Whiteout")
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
        }
        .frame(width: 300)
        .padding()
        .onAppear {
            widthText = String(format: "%.0f", width.wrappedValue)
        }
    }
}

#Preview {
    @Previewable @State var preset = ToolPreset.newDefault(for: .whiteout)
    
    WhiteoutEditorView(preset: Binding(
        get: { preset },
        set: { preset = $0 }
    ),
                       remove: {})
}
