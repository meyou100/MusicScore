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
        canvasView.isOpaque = false
        canvasView.tool = tool
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        context.coordinator.parent = self  
        uiView.tool = tool

        if !context.coordinator.isUpdatingFromCanvas,
           let newDrawing = try? PKDrawing(data: drawingData),
           newDrawing != uiView.drawing {
            uiView.drawing = newDrawing
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        var parent: PencilCanvasView
        var isUpdatingFromCanvas = false

        init(_ parent: PencilCanvasView) {
            self.parent = parent
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            isUpdatingFromCanvas = true
            parent.drawingData = canvasView.drawing.dataRepresentation()
            DispatchQueue.main.async { [weak self] in
                self?.isUpdatingFromCanvas = false
            }
        }
    }
}
