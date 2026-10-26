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
    let removable: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            GeneralBar(preset: $preset, remove: remove, removable: removable, resetable: true)
            
            StrokeWidthBar(preset: $preset)
            
            ColorBar(preset: $preset)
        }
        .padding()
        .frame(width: 300)
    }
}


#Preview {
    @Previewable @State var preset = ToolPreset.newDefault(for: .pen)
    
    InkEditorView(preset: Binding(
        get: { preset },
        set: { preset = $0 }
    ),
                  remove: {}, removable: false)
}
