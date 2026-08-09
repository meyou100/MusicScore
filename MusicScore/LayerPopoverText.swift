//
//  LayerPopoverText.swift
//  MusicScore
//
//  Created by Jonny C on 8/6/26.
//

import SwiftUI
import PencilKit

struct LayerPopoverText: View {
    @Binding var layers: [DrawingLayer]
    @Environment(\.dismiss) private var dismiss
    
    @State private var renamingLayerID: DrawingLayer.ID? = nil
    @State private var renameText: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Layers")
                .font(.headline)
                .padding()
            
            Divider()
            
            List {
                ForEach($layers) { $layer in
                    HStack {
                        Button {
                            layer.isVisible.toggle()
                        } label: {
                            Image(systemName: layer.isVisible ? "eye" : "eye.slash")
                        }
                        .buttonStyle(.plain)
                        
                        if renamingLayerID == layer.id {
                            TextField("Name", text: $renameText, onCommit: {
                                layer.name = renameText
                                renamingLayerID = nil
                            })
                            .textFieldStyle(.roundedBorder)
                        } else {
                            Text(layer.name)
                                .onTapGesture {
                                    renameText = layer.name
                                    renamingLayerID = layer.id
                                }
                        }
                        
                        Spacer()
                        
                        Menu {
                            Button {
                                renameText = layer.name
                                renamingLayerID = layer.id
                            } label: {
                                Label("Rename", systemImage: "pencil")
                            }
                            
                            Button {
                                duplicate(layer)
                            } label: {
                                Label("Duplicate", systemImage: "plus.square.on.square")
                            }
                            
                            Button {
                                layer.canvas.drawing = PKDrawing()
                            } label: {
                                Label("Clear", systemImage: "xmark.circle")
                            }
                            
                            Button(role: .destructive) {
                                delete(layer)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        } label: {
                            Image(systemName: "ellipsis.circle")
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .listStyle(.plain)
        }
        .frame(width: 280, height: 300)
    }
    
    private func duplicate(_ layer: DrawingLayer) {
        guard let index = layers.firstIndex(where: { $0.id == layer.id }) else { return }
        var copy = layer
        copy.id = UUID() // assuming DrawingLayer.id is a var UUID, adjust as needed
        copy.name = layer.name + " Copy"
        layers.insert(copy, at: index + 1)
    }
    
    private func delete(_ layer: DrawingLayer) {
        layers.removeAll { $0.id == layer.id }
    }
}

#Preview {
    @Previewable @State var layers = [DrawingLayer(canvas: PassThroughCanvasView(), name: "whiteout"), DrawingLayer(canvas: PassThroughCanvasView(), name: "layer 1")]
    LayerPopoverText(layers: $layers)
}
