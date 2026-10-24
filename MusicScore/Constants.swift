//
//  Constants.swift
//  MusicScore
//
//  Created by Jonny C on 8/1/26.
//

import Foundation
import SwiftUI

struct Constants {
    
    static let toolbarIconSize: CGFloat = 24
    
    static let commonColors: [Color] = [
        .black, .white, .red, .orange, .yellow, .green, .blue, .indigo, .purple, .brown, .pink, .cyan, .teal, .mint
    ]
    
    static let stamps: [String] = [
        
    ]
    
    static var tools: [ToolPreset] = [
            ToolPreset.newDefault(for: .pen),
            ToolPreset.newDefault(for: .eraser),
            ToolPreset.newDefault(for: .whiteout),
            ToolPreset.newDefault(for: .highlighter),
            ToolPreset.newDefault(for: .lasso),
            ToolPreset.newDefault(for: .stamp)
            ]
}
