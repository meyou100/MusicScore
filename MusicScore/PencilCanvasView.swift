//
//  PencilCanvasView.swift
//  MusicScore
//
//  Created by Jonny C on 8/2/26.
//

import SwiftUI
import PencilKit

struct PencilCanvasView: UIViewRepresentable {
    @Binding var drawingData: Data
    let tool: PKTool
    
    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.drawing = (try? PKDrawing(data: drawingData)) ?? PKDrawing()
        canvasView.delegate = context.coordinator
        canvasView.drawingPolicy = .pencilOnly
        canvasView.backgroundColor = .clear
        canvasView.backgroundColor = .clear
        canvasView.tool = tool
        canvasView.isOpaque = false
        
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        let currentData = uiView.drawing.dataRepresentation()
        if currentData != drawingData {
            uiView.drawing = (try? PKDrawing(data: drawingData)) ?? PKDrawing()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilCanvasView
        
        init(_ parent: PencilCanvasView) {
            self.parent = parent
        }
        
        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            parent.drawingData = canvasView.drawing.dataRepresentation()
        }
    }
}
