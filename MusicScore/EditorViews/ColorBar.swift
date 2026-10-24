//
//  ColorBar.swift
//  MusicScore
//
//  Created by Jonny Chang on 8/30/26.
//

import SwiftUI

struct ColorBar: View {
    @Binding var preset: ToolPreset
    
    private var color: Binding<Color> {
        Binding(
            get: { preset.color ?? .black },
            set: { preset.color = $0 }
        )
    }
    
    var body: some View {
        VStack {
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
    }
    
    private func selectedRingColor(for swatch: Color) -> Color {
        return swatch == .white ? .gray : .white
    }
}

#Preview {
    @Previewable @State var preset = ToolPreset.newDefault(for: .highlighter)
    ColorBar(preset: Binding (
        get: {preset },
        set: {preset = $0}
    ))
}
