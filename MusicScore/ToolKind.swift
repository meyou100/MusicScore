//
//  ToolKind.swift
//  MusicScore
//
//  Created by Jonny C on 8/2/26.
//

import SwiftUI
import PencilKit

enum ToolKind: String, CaseIterable {
    case ink, whiteout, eraser, highlighter, lasso, stamp
    
    var label: String {
        switch self {
        case .ink: return "Pen"
        case .whiteout: return "Whiteout"
        case .eraser: return "Eraser"
        case .highlighter: return "Highlighter"
        case .lasso: return "Lasso"
        case .stamp: return "Stamp"
        }
    }
    
    var icon: (isSystemSymbol: Bool, name: String) {
        switch self {
        case .ink: return (true, "pencil")
        case .whiteout: return (false, "whiteoutIcon")
        case .eraser: return (true, "eraser")
        case .highlighter: return (false, "highlighterIcon")
        case .lasso: return (true, "lasso")
        case .stamp: return (false, "stampIcon")
        }
    }
    
    var defaultEditingWhiteout: Bool {
        switch self {
        case .ink, .eraser, .highlighter, .lasso, .stamp: return false
        case .whiteout: return true
        }
    }
    
    var defaultColor: Color? {
        switch self {
        case .ink: return .black
        case .whiteout: return .white
        case .highlighter: return .yellow
        case .lasso, .stamp, .eraser: return nil
        }
    }
    
    var defaultWidth: CGFloat? {
        switch self {
        case .ink: return 5
        case .whiteout: return 5
        case .eraser: return 5
        case .highlighter: return 5
        case .lasso: return nil
        case .stamp: return 5
        }
    }
    
    var defaultEraserType: PKEraserTool.EraserType? {
        switch self {
        case .ink, .whiteout, .highlighter, .lasso, .stamp: return nil
        case .eraser: return .bitmap
        }
    }
    
    var defaultOpacity: Double? {
        switch self {
        case .ink, .whiteout: return 1
        case .highlighter: return 0.8
        case .eraser, .lasso, .stamp: return nil
        }
    }
    
    var defaultStampName: String? {
        switch self {
        case .ink, .whiteout, .highlighter, .lasso, .eraser: return nil
        case .stamp: return "" // fix this
        }
    }
    
    var isErasing: Bool {
        self == .eraser
    }
    
    func makePKTool(color: Color?, width: CGFloat?, eraserType: PKEraserTool.EraserType?, opacity: Double?) -> PKTool {
        switch self {
        case .ink: return PKInkingTool(.pen, color: UIColor(color ?? .black), width: width)
        case .whiteout: return PKInkingTool(.pen, color: .white, width: width)
        case .eraser: return PKEraserTool(eraserType ?? self.defaultEraserType ?? .vector, width: width ?? self.defaultWidth ?? 1)
        case .highlighter: return PKInkingTool(.marker, color: UIColor(color ?? .yellow).withAlphaComponent(opacity ?? self.defaultOpacity ?? 0.8), width: width) //check whether marker or .pen is better for opacity
        case .lasso: return PKLassoTool()
        case .stamp: return PKInkingTool(.pen, color: UIColor(color ?? .black), width: width) // fix this
        }
    }
    
    @ViewBuilder
    func editorView(preset: Binding<ToolPreset>, remove: @escaping () -> Void) -> some View {
        switch self {
        case .ink: InkEditorView(preset: preset, remove: remove)
        case .whiteout: WhiteoutEditorView(preset: preset, remove: remove)
        case .eraser: EraserEditorView(preset: preset, remove: remove)
        case .highlighter: HighlighterEditorView(preset: preset, remove: remove)
        case .lasso: Text("No settings for lasso").padding()
        case .stamp: StampEditorView(preset: preset, remove: remove)
        }
    }
}
