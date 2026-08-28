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
    
    private var width: Binding<CGFloat> {
        Binding(
            get: { preset.width ?? 5 },
            set: { preset.width = $0 }
        )
    }
    
    private var stamp: Binding<String> {
        Binding(
            get: { preset.stampName ?? "" },
            set: { preset.stampName = $0 }
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
                
                Text("Stamp")
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
        .frame(width: 300)
        .padding()
        .onAppear {
        }
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
