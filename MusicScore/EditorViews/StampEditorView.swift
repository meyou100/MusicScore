//
//  StampEditorView.swift
//  MusicScore
//
//  Created by Jonny C on 8/3/26.
//


//implement
import SwiftUI

struct StampEditorView: View {
    @Binding var preset: ToolPreset
    var remove: () -> Void
    let removable: Bool
    
    private var stamp: Binding<String> {
        Binding(
            get: { preset.stampName ?? "" },
            set: { preset.stampName = $0 }
        )
    }
    
    var body: some View {
        VStack(spacing: 15) {
            GeneralBar(preset: $preset, remove: remove, removable: removable, resetable: true)
            
        }
        .frame(width: 300)
        .padding()
    }
}

#Preview {
    @Previewable @State var preset = ToolPreset.newDefault(for: .stamp)
    
    StampEditorView(preset: Binding(
        get: { preset },
        set: { preset = $0 }
    ),
                    remove: {}, removable: true)
}
