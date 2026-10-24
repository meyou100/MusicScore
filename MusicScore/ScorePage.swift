//
//  ScorePage.swift
//  MusicScore
//
//  Created by Jonny C on 8/1/26.
//

import SwiftUI
import PencilKit

struct ScorePage: View {
    @Bindable var score: Score
    @Environment(\.dismiss) private var dismiss
    @Environment(\.undoManager) private var undoManager
    
    var pageIndex: Int
    
    @State private var isErasing: Bool = false
    @State private var activeToolIndex: Int = 0
    @State private var editingPresetIndex: Int? = nil
    @State private var activeLayer: Int = 1
    @State private var showLayerPopover: Bool = false
    @State private var currentPage: Int = 0
    
    var body: some View {
        ZStack(alignment: .topLeading) {
//            let _ = print(score.pdfPages.count, currentPage)
            PDFPageView(page: score.pdfPages[currentPage])
                .ignoresSafeArea()
                
            ForEach(Array(score.layers.enumerated()), id: \.element.id) { i, layer in
//                let _ =  print("\(i) \(layer.pages.count) \(currentPage)")

                PencilCanvasView(
                    drawingData: $score.layers[i].pages[currentPage].drawingData,
                    tool: Constants.tools[activeToolIndex].makePKTool()
                )
                    .ignoresSafeArea()
                    .opacity(layer.isVisible ? 1 : 0)
                    .allowsHitTesting(getActiveLayer() == i)
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
//                            LayerPopover(layers: $score.layers, activeLayer: $activeLayer, activeTool: Constants.tools[activeToolIndex].makePKTool())
                        }
                    }
                    .font(.system(size: 20, weight: .semibold))
                    .padding(10)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                    
                    Button {
                        score.layers[0].isVisible.toggle()
                    } label: {
                        Image(systemName: score.layers[0].isVisible ? "eye" : "eye.slash")
                            .font(.system(size: 22, weight: .semibold))
                            .padding(10)
                            .frame(height: 22) 
                    }
                }
                .padding()
                
                Spacer()
                
                HStack(spacing: 0) {
                    HStack(spacing: 3) {
                        ForEach(Array(Constants.tools.enumerated()), id: \.element.id) { i, toolPreset in
                            Button {
                                if activeToolIndex == i {
                                    editingPresetIndex = i
                                } else {
                                    isErasing = toolPreset.kind.isErasing
                                    activeToolIndex = i
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
                                Constants.tools[i].kind.editorView(
                                    preset: Binding(
                                        get: { Constants.tools[i] },
                                        set: { Constants.tools[i] = $0 }
                                    ),
                                    remove: {
                                        Constants.tools.remove(at: i)
                                        editingPresetIndex = nil
                                        if !Constants.tools.isEmpty {
                                            activeToolIndex = 0
                                        }
                                    },
                                    removable: Constants.tools.count > 1
                                )
                            }
                            
                        }
                    }
                    .padding(.horizontal, 4)
                    
                    Menu {
                        ForEach(ToolKind.allCases, id: \.self) { kind in
                            Button {
                                Constants.tools.append(ToolPreset.newDefault(for: kind))
                                activeToolIndex = Constants.tools.count - 1
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
    }
    
    private func getActiveLayer() -> Int {
        if Constants.tools[activeToolIndex].editingWhiteout {
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

//#Preview {
//    if let u = Bundle.main.url(forResource: "26F-Concertmaster", withExtension: "pdf"),
//           let s = Score(file: u) {
//        ScorePage(score: s, pageIndex:0)
//        } else {
//            Text("Failed to load preview score")
//        }
//}
