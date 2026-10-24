//
//  GeneralBar.swift
//  MusicScore
//
//  Created by Jonny Chang on 8/30/26.
//

import SwiftUI

struct GeneralBar: View {
    @Binding var preset: ToolPreset
    var remove: () -> Void
    let removable: Bool
    let resetable: Bool
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button {
                    preset.reset()
                } label: {
                    Text("Reset")
                }
                .disabled(!resetable)
                
                Spacer()
                
                Text(preset.kind.label)
                    .font(.headline)
                
                Spacer()
                
                Button(role: .destructive) {
                    remove()
                } label: {
                    Text("Remove")
                }
                .disabled(!removable)
            }
            
            Divider()
                .padding(.vertical, 10)
        }
    }
}

#Preview {
    @Previewable @State var preset = ToolPreset.newDefault(for: .lasso)
    
    GeneralBar(preset: Binding(
        get: { preset },
        set: { preset = $0 }
    ),
               remove: {}, removable: true, resetable: false)
}
