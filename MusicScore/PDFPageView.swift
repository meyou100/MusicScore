//
//  PDFPageView.swift
//  MusicScore
//
//  Created by Jonny Chang on 8/30/26.
//

import SwiftUI
import PDFKit

struct PDFPageView: UIViewRepresentable {
    let page: PDFPage
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = page.document
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .horizontal
        pdfView.usePageViewController(true, withViewOptions: nil as [String: Any]?)
        pdfView.go(to: page)
        return pdfView
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.go(to: page)
        if uiView.bounds.width > 0 && uiView.bounds.height > 0 {
            uiView.autoScales = true
            
        }
    }
}
