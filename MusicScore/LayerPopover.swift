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
    
    var body: some View {
        VStack {
            Text("Layers")
                .font(.headline)
                .bold()
            
            Divider()
                .padding(.vertical, 10)
            
            ForEach(Array(layers.enumerated()), id: \.element.id) {i, layer in
                HStack {
                    Text(layer.name)
                    
                    Spacer()
                    
                    Button {
                        layers[i].isVisible.toggle()
                    } label: {
                        Image(systemName: layer.isVisible ? "eye" : "eye.slash")
                    }
                    
                    Menu {
                        Button {
                            
                        } label: {
                            Label("Rename", systemImage: "pencil")
                        }
                        
                        Button {
                            
                        } label: {
                            Label("Duplicate", systemImage: "plus.square.on.square")
                        }
                        
                        Button {
                            layer.canvas.drawing = PKDrawing()
                        } label: {
                            Label("Clear", systemImage: "xmark.circle")
                        }
                        
                        Button(role: .destructive) {
                            if i == 0 {
                                Text("Cannot delete the whiteout layer")
                            } else if layers.count == 2 {
                                Text("Cannot delete the only normal layer")
                            } else {
                                //delete
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
        .frame(width: 400)
        .padding()
    }
}

#Preview {
    @Previewable @State var layers = [DrawingLayer(canvas: PassThroughCanvasView(), name: "whiteout"), DrawingLayer(canvas: PassThroughCanvasView(), name: "layer 1"), DrawingLayer(canvas: PassThroughCanvasView(), name: "layer 2")]
    LayerPopover(layers: $layers)
}
