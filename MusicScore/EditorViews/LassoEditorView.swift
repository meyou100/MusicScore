//
//  LassoEditorView.swift
//  MusicScore
//
//  Created by Jonny Chang on 8/16/26.
//

import SwiftUI

struct LassoEditorView: View {
    @Binding var preset: ToolPreset
    var remove: () -> Void
    let removable: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            GeneralBar(preset: $preset, remove: remove, removable: removable, resetable: false)
            
            Text("No settings for lasso")
        }
        .frame(width: 300)
        .padding()
    }
}

#Preview {
    @Previewable @State var preset = ToolPreset.newDefault(for: .lasso)
    LassoEditorView(preset: Binding(
        get: { preset },
        set: { preset = $0 }
    ), remove: {}, removable: true)
}
