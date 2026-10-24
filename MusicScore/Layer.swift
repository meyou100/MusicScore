//
//  Layer.swift
//  MusicScore
//
//  Created by Jonny Chang on 8/30/26.
//

import SwiftUI

struct Layer: Codable {
    var name: String
    var isVisible: Bool = true
    var id = UUID()
    var pages: [LayerPage]
    
    static func defaultLayer(numberOfLayers: Int, numberOfPages: Int) -> Layer {
        return Layer(name: "Layer \(numberOfLayers - 1)", pages: Array(repeating: LayerPage.defaultLayerPage(), count: numberOfPages))
    }
}
