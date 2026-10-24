//
//  ToolPreset.swift
//  MusicScore
//
//  Created by Jonny C on 8/2/26.
//

import PencilKit
import SwiftUI

struct ToolPreset: Identifiable {
    let id = UUID()
    var kind: ToolKind
    var color: Color?
    var width: CGFloat?
    var eraserType: PKEraserTool.EraserType?
    var opacity: Double?
    var stampName: String?
    var editingWhiteout: Bool
    
    static func newDefault(for kind: ToolKind) -> ToolPreset {
        ToolPreset(kind: kind, color: kind.defaultColor, width: kind.defaultWidth, eraserType: kind.defaultEraserType, opacity: kind.defaultOpacity, stampName: kind.defaultStampName, editingWhiteout: kind.defaultEditingWhiteout)
    }
    
    func makePKTool() -> PKTool {
        kind.makePKTool(color: color, width: width, eraserType: eraserType, opacity: opacity)
    }
    
    mutating func reset() {
        self.color = self.kind.defaultColor
        self.width = self.kind.defaultWidth
        self.eraserType = self.kind.defaultEraserType
        self.opacity = self.kind.defaultOpacity
        self.stampName = self.kind.defaultStampName
        self.editingWhiteout = self.kind.defaultEditingWhiteout
    }
}
