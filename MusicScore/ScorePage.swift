//
//  ScorePage.swift
//  MusicScore
//
//  Created by Jonny C on 8/1/26.
//

import SwiftUI
import PencilKit

struct ScorePage: View {
    let score: Score
    @Environment(\.dismiss) private var dismiss
    @Environment(\.undoManager) private var undoManager
    
    @State private var layers: [DrawingLayer] = [//Change this to be serialized between uses of the app
        DrawingLayer(canvas: PassThroughCanvasView(), name: "Whiteout"),
        DrawingLayer(canvas: PassThroughCanvasView(), name: "Layer 1")
    ]
    
    @State private var toolPresets: [ToolPreset] = [//Change this to be serialized between uses of the app
        ToolPreset.newDefault(for: .pen),
        ToolPreset.newDefault(for: .eraser),
        ToolPreset.newDefault(for: .whiteout),
        ToolPreset.newDefault(for: .highlighter),
        ToolPreset.newDefault(for: .lasso),
        ToolPreset.newDefault(for: .stamp),
    ]
    
    @State private var isErasing: Bool = false
    @State private var activeToolIndex: Int = 0
    @State private var editingPresetIndex: Int? = nil
    @State private var activeLayer: Int = 1
    @State private var showLayerPopover: Bool = false
    
    @State private var selectedColor: Color? = nil //are these even used?
    @State private var selectedWidth: CGFloat? = nil
    
    
    var fileUrl: URL? { Bundle.main.url(forResource: score.fileName, withExtension: "pdf") }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if let fileUrl = fileUrl {
                PDFKitView(url: fileUrl)
                    .ignoresSafeArea()
                
                ForEach(Array(layers.enumerated()), id: \.element.id) { i, layer in
                    PencilCanvasView(canvasView: $layers[i].canvas)
                        .ignoresSafeArea()
                        .opacity(layer.isVisible ? 1 : 0)
                        .allowsHitTesting(getActiveLayer() == i)
                }
            } else {
                Text("File not found")
            }
            
            VStack {
                HStack {
                    HStack(spacing: 20) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                        }
                        
                        Button {
                            undoManager?.undo()
                        } label: {
                            Image(systemName: "arrow.uturn.backward")
                        }
                        
                        Button {
                            undoManager?.redo()
                        } label: {
                            Image(systemName: "arrow.uturn.forward")
                        }
                        
                        Button {
                            showLayerPopover = true
                        } label: {
                            Image(systemName: "square.3.layers.3d")
                        }
                        .popover(isPresented: $showLayerPopover) {
                            LayerPopover(layers: $layers, activeLayer: $activeLayer, activeTool: toolPresets[activeToolIndex].makePKTool())
                        }
                    }
                    .font(.system(size: 20, weight: .semibold))
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                    
                    Button {
                        layers[0].isVisible.toggle()
                    } label: {
                        Image(systemName: layers[0].isVisible ? "eye" : "eye.slash")
                            .font(.system(size: 22, weight: .semibold))
                            .padding(10)
                            .frame(height: 22) 
                    }
                }
                .padding()
                
                Spacer()
                
                HStack(spacing: 0) {
                    HStack(spacing: 3) {
                        ForEach(Array(toolPresets.enumerated()), id: \.element.id) { i, toolPreset in
                            Button {
                                if activeToolIndex == i {
                                    editingPresetIndex = i
                                } else {
                                    isErasing = toolPreset.kind.isErasing
                                    activeToolIndex = i
                                    applyActiveTool()
                                }
                            } label: {
                                VStack(spacing: 2) {
                                    iconView(icon: toolPreset.kind.icon)
                                    
                                    if let color = toolPreset.color {
                                        RoundedRectangle(cornerRadius: 3)
                                            .fill(color)
                                            .frame(width: 15, height: 3)
                                    }
                                }
                                .frame(width: 20, height: 25)
                                .padding(6)
                                .background(activeToolIndex == i ? .blue.opacity(0.3) : .clear)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .popover(isPresented: Binding(
                                get: { editingPresetIndex == i },
                                set: { if !$0 {editingPresetIndex = nil } }
                            )) {
                                toolPresets[i].kind.editorView(
                                    preset: Binding(
                                        get: { toolPresets[i] },
                                        set: { toolPresets[i] = $0; applyActiveTool() }
                                    ),
                                    remove: {
                                        toolPresets.remove(at: i)
                                        editingPresetIndex = nil
                                        if !toolPresets.isEmpty {
                                            activeToolIndex = 0
                                            applyActiveTool()
                                        }
                                    },
                                    removable: toolPresets.count > 1
                                )
                            }
                            
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    Menu {
                        ForEach(ToolKind.allCases, id: \.self) { kind in
                            Button {
                                toolPresets.append(ToolPreset.newDefault(for: kind))
                                activeToolIndex = toolPresets.count - 1
                                applyActiveTool()
                            } label: {
                                Text(kind.label)
                                iconView(icon: kind.icon)
                            }
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    } 
                    .padding(.horizontal, 8)
                }
                .padding(.vertical, 3)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            applyActiveTool()
            selectedColor = toolPresets[0].color
            selectedWidth = toolPresets[0].width
        }
    }
        
    private func applyActiveTool() {
        let t = toolPresets[activeToolIndex].makePKTool()
        for layer in layers {
            layer.canvas.tool = t
        }
    }
    
    private func getActiveLayer() -> Int {
        if toolPresets[activeToolIndex].editingWhiteout {
            return 0
        } else {
            return activeLayer
        }
    }
    
    @ViewBuilder
    func iconView(icon: (isSystemSymbol: Bool, name: String)) -> some View {
        if icon.isSystemSymbol {
            Image(systemName: icon.name)
                .font(.system(size: 16, weight: .semibold))
                .frame(height: 30)
        } else {
            Image(icon.name)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 30)
        }
    }
}

#Preview {
    ScorePage(score: Score(title: "Test", pageCount: 1, size: 0.1, fileName: "26F-Concertmaster"))
}
