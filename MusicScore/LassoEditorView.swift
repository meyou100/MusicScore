//
//  LassoEditorView.swift
//  MusicScore
//
//  Created by Jonny Chang on 8/16/26.
//

import SwiftUI

struct LassoEditorView: View {
    var remove: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            ZStack {
                Text("Lasso")
                    .font(.headline)
                
                HStack {
                    Spacer()
                    
                    Button(role: .destructive) {
                        remove()
                    } label: {
                        Text("Remove")
                    }
                }
            }
            
            Divider()
                .padding(.vertical, 10)
            
            Text("No settings for lasso")
        }
        .frame(width: 300)
        .padding()
    }
}

#Preview {
    LassoEditorView(remove: {})
}
