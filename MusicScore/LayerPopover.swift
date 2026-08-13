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
    
    @State private var deleteAlertMessage: String? = nil
    
    var body: some View {
        VStack {
            ZStack {
                Text("Layers")
                    .font(.headline)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .center)
                 
                HStack {
                    Button {
                        
                    } label: {
                        Image("merge")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 20)
                        
                    }
                    
                    Button {
                        layers.append(DrawingLayer(canvas: PassThroughCanvasView(), name: "Layer \(layers.count)"))
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
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
                        
                        Button { //make sure the duplicate button works properly
                            let canvasCopy = PassThroughCanvasView()
                            canvasCopy.drawing = layer.canvas.drawing
                            layers.insert(DrawingLayer(canvas: canvasCopy, name: "Copy of " + layer.name.trimmingCharacters(in: .whitespacesAndNewlines), isVisible: layer.isVisible, id: UUID()), at: i + 1)
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
                                deleteAlertMessage = "Cannot delete the whiteout layer"
                            } else if layers.count == 2 {
                                deleteAlertMessage = "Cannot delete the only normal layer"
                            } else {
                                layers.remove(at: i)
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
        .popover(isPresented: Binding(
            get: { deleteAlertMessage != nil },
            set: { if !$0 { deleteAlertMessage = nil } }
        )) {
            Text(deleteAlertMessage ?? "")
                .padding()
                .frame(width: 200)
        }
    }
}

#Preview {
    @Previewable @State var layers = [DrawingLayer(canvas: PassThroughCanvasView(), name: "whiteout"), DrawingLayer(canvas: PassThroughCanvasView(), name: "layer 1"), DrawingLayer(canvas: PassThroughCanvasView(), name: "layer 2")]
    LayerPopover(layers: $layers)
}
