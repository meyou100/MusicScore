//
//  PencilCanvasView.swift
//  MusicScore
//
//  Created by Jonny C on 8/2/26.
//

import SwiftUI

struct PencilCanvasView: UIViewRepresentable {
    @Binding var canvasView: PassThroughCanvasView
    
    func makeUIView(context: Context) -> PassThroughCanvasView {
        canvasView.drawingPolicy = .pencilOnly
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PassThroughCanvasView, context: Context) {
    }
}
