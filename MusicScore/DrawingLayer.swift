//
//  DrawingLayer.swift
//  MusicScore
//
//  Created by Jonny C on 8/6/26.
//

import SwiftUI

struct DrawingLayer: Identifiable {
    var canvas: PassThroughCanvasView
    var name: String
    var isVisible: Bool = true
    var id = UUID()
}
