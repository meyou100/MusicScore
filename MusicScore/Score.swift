//
//  Score.swift
//  MusicScore
//
//  Created by Jonny Chang on 8/27/26.
//

import Foundation
import PDFKit
import SwiftUI
import SwiftData

@Model
class Score {
    var title: String
    var pageCount: Int
    var size: Float
    var fileName: String
    
    var file: URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(fileName)
        }
    
    @Transient
        private var _pdf: PDFDocument?

        var pdf: PDFDocument {
            if let _pdf { return _pdf }
            let doc = PDFDocument(url: file) ?? PDFDocument()
            _pdf = doc
            return doc
        }

        var pdfPages: [PDFPage] {
//            print("pdf: \(pdf.pageCount)")
            return (0..<pdf.pageCount).compactMap { pdf.page(at: $0) }
        }

    var layers: [Layer]
    var activePage: Int
        
    init?(fileName: String) {
        self.fileName = fileName
        let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                    .appendingPathComponent(fileName)
        guard let document = PDFDocument(url: file) else { return nil }
        self.pageCount = document.pageCount
        self.title = file.lastPathComponent
        self.size = 0
        activePage = 0
        let pageCount = document.pageCount
        layers = [
            Layer(name: "Whiteout", pages: Array(repeating: LayerPage.defaultLayerPage(), count: pageCount)),
            Layer(name: "Layer 1", pages: Array(repeating: LayerPage.defaultLayerPage(), count: pageCount))
        ]
        self._pdf = document
        print("calling init")
        print("\(pageCount)")
//        do {
//            let byteCount = try url?.resourceValues(forKeys: [.fileSizeKey])
//            size
//        } catch {
//            size = 0
//        } implement size
    }
}
