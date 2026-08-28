//
//  LayerPopover.swift
//  MusicScore
//
//  Created by Jonny C on 8/6/26.
//

import SwiftUI
import PencilKit

struct LayerPopover: View {
    @Binding var layers: [DrawingLayer]
    @Binding var activeLayer: Int
    let activeTool: PKTool
    
    @State private var renameLayer: Int = -1
    @State private var renameText: String = ""
    @State private var isMultipleSelection: Bool = false
    @State private var selectedLayers: [Bool] = []
    
    @FocusState private var isRenameFocused: Bool
    
    private var layersSelected: Int {
        return selectedLayers.dropFirst().count { $0 }
    }
    
    var body: some View {
        VStack {
            ZStack {
                Text("Layers")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                 
                HStack {
                    if isMultipleSelection {
                        Button {
                            isMultipleSelection = false
                        } label: {
                            Image(systemName: "chevron.left")
                                .frame(width: 25, height: 20)
                        }
                        
                        Button {
                            var first = -1
                            var merged: [PKStroke] = []
                            for i in layers.indices {
                                if selectedLayers[i] {
                                    if first == -1 {
                                        first = i
                                    }
                                    
                                    if activeLayer == i {
                                        activeLayer = first
                                    }
                                    
                                    merged += layers[i].canvas.drawing.strokes
                                }
                            }
                            layers[first].canvas.drawing = PKDrawing(strokes: merged)
                            selectedLayers[first] = false
                            
                            deleteSelectedLayers()
                        } label: {
                            Image("merge")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 20)
                        }
                        .disabled(layersSelected < 2)
                        
                        Button(role: .destructive) {
                            deleteSelectedLayers()
                        } label: {
                            Image(systemName: "trash")
                                .frame(width: 25, height: 20)
                        }
                        .disabled(layersSelected == 0 || layersSelected == layers.count - 1)
                    } else {
                        Button {
                            isMultipleSelection = true
                            selectedLayers = [Bool](repeating: false, count: layers.count)
                        } label: {
                            Image(systemName: "checkmark.rectangle.stack")
                                .frame(width: 25, height: 20)
                        }
                        
                        Button {
                            layers.append(DrawingLayer(canvas: PassThroughCanvasView(), name: "Layer \(layers.count)"))
                            
                            layers[layers.count - 1].canvas.tool = activeTool
                        } label: {
                            Image(systemName: "plus")
                                .frame(width: 25, height: 20)
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 10, maxHeight: 10, alignment: .trailing)
            }
            
            Divider()
                .padding(.vertical, 10)
            
            ForEach(Array(layers.enumerated()), id: \.element.id) {i, layer in
                HStack {
                    if isMultipleSelection && i > 0 {
                        Button {
                            selectedLayers[i].toggle()
                        } label: {
                            Image(systemName: selectedLayers[i] ? "checkmark.circle" : "circle")
                        }
                    }
                    
                    if renameLayer == i {
                        TextField("Layer Name", text: $renameText, onCommit: {
                            layers[i].name = renameText
                            renameLayer = -1
                            isRenameFocused = false
                        })
                            .textFieldStyle(.roundedBorder)
                            .frame(height: 30, alignment: .leading)
                            .focused($isRenameFocused)
                            .onChange(of: isRenameFocused, { _, isFocused in
                                if !isFocused {
                                    layers[i].name = renameText
                                    renameLayer = -1
                                }
                            })
                            .onAppear {
                                isRenameFocused = true
                            }
                    } else {
                        if i > 0 {
                            Button {
                                activeLayer = i
                            } label: {
                                Text(layer.name)
                                    .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 30, alignment: .leading)
                                    .foregroundColor(activeLayer == i ? .blue : .black)
                            }
                        } else {
                            Text(layer.name)
                                .frame(height: 30, alignment: .leading)
                                .foregroundColor(.black)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        layers[i].isVisible.toggle()
                    } label: {
                        Image(systemName: layer.isVisible ? "eye" : "eye.slash")
                            .frame(height: 30)
                    }
                    
                    if isMultipleSelection {
                        if i > 0 {
                            Image(systemName: "line.3.horizontal")
                                .frame(width: 20, height: 20)
                        } else {
                            Color.clear.frame(width: 20, height: 20)
                        }
                    } else {
                        Menu {
                            if i > 0 {
                                Button {
                                    renameLayer = i
                                    renameText = layer.name
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                            }
                            
                            Button { //make sure the duplicate button works properly
                                let canvasCopy = PassThroughCanvasView()
                                canvasCopy.drawing = layer.canvas.drawing
                                layers.insert(DrawingLayer(canvas: canvasCopy, name: "Copy of " + layer.name.trimmingCharacters(in: .whitespacesAndNewlines), isVisible: layer.isVisible, id: UUID()), at: i + 1)
                                activeLayer += 1
                                layers[activeLayer].canvas.tool = activeTool
                            } label: {
                                Label("Duplicate", systemImage: "plus.square.on.square")
                            }
                            
                            Button {
                                layer.canvas.drawing = PKDrawing()
                            } label: {
                                Label("Clear", systemImage: "xmark.circle")
                            }
                            
                            if layers.count > 2 && i > 0 {
                                Button(role: .destructive) {
                                    if i == activeLayer {
                                        activeLayer = max(1, i - 1)
                                    } else if activeLayer > i {
                                        activeLayer -= 1
                                    }
                                    
                                    layers.remove(at: i)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }
            }
            .frame(height: 25)
        }
        .frame(width: 400)
        .padding()
    }
    
    private func deleteSelectedLayers() {
        for i in layers.indices.reversed() {
            if selectedLayers[i] {
                if activeLayer == i {
                    activeLayer = max(1, i - 1)
                } else if activeLayer > i {
                    activeLayer -= 1
                }
                
                layers.remove(at: i)
                selectedLayers.remove(at: i)
            }
        }
    }
}

#Preview {
    @Previewable @State var layers = [DrawingLayer(canvas: PassThroughCanvasView(), name: "whiteout"), DrawingLayer(canvas: PassThroughCanvasView(), name: "layer 1"), DrawingLayer(canvas: PassThroughCanvasView(), name: "layer 2")]
    @Previewable @State var activeLayer = 1
    LayerPopover(layers: $layers, activeLayer: $activeLayer, activeTool: PKLassoTool())
}
