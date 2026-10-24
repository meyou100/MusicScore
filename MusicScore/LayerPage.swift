//
//  LayerPage.swift
//  MusicScore
//
//  Created by Jonny Chang on 8/30/26.
//

import Foundation
import PencilKit

struct LayerPage: Codable {
    var drawingData: Data
    
    static func defaultLayerPage() -> LayerPage {
        return LayerPage(drawingData: Data())
    }
}

