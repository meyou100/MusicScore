//
//  PDFKitView.swift
//  MusicScore
//
//  Created by Jonny C on 8/2/26.
//

import PDFKit
import SwiftUI

struct PDFKitView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true, withViewOptions: nil as [String: Any]?)
        
        pdfView.addGestureRecognizer(
            UITapGestureRecognizer(
                target: context.coordinator,
                action: #selector(Coordinator.handleTap(_:))
            )
        )

        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator: NSObject {
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            guard let pdfView = gesture.view as? PDFView else { return }
            let tapLocation = gesture.location(in: pdfView)
            let width = pdfView.bounds.width
            
            if tapLocation.x < width / 3 {
                pdfView.goToPreviousPage(nil)
            } else if tapLocation.x > width * 2 / 3 {
                pdfView.goToNextPage(nil)
            }
        }
    }
}
