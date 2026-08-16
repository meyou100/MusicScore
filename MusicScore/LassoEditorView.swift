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
            HStack {
                Text("Lasso")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                
                Button(role: .destructive) {
                    remove()
                } label: {
                    Text("Remove")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }
            
            Text("No settings for lasso")
        }
        .frame(width: 300)
        .padding()
    }
}

#Preview {
    LassoEditorView(remove: {})
}
