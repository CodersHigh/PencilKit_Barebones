//
//  DrawingView.swift
//  PencilKit_Barebones
//
//  Created by 이로운 on 2022/07/26.
//

import SwiftUI
import CoreData
import PencilKit

struct DrawingView: View {
    @ObservedObject var viewModel: DrawingViewModel
    @State var drawing: Drawing
    
    var body: some View {
        DrawingCanvasView(drawing: $drawing)
            .navigationTitle(drawing.title ?? "Untitled")
    }
}

struct DrawingCanvasView: UIViewRepresentable {
    
    @State private var canvas = PKCanvasView()
    @Binding var drawing: Drawing
    
    func makeUIView(context: Context) -> PKCanvasView {
        
        canvas.drawingPolicy = .anyInput
        
        if let drawing = try? PKDrawing(data: drawing.data ?? Data()) {
            canvas.drawing = drawing
        }
        
        return canvas
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        
    }
    
}


