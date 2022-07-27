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
    @State private var canvasView = PKCanvasView()
    
    var body: some View {
        DrawingCanvasView(canvasView: canvasView, drawing: $drawing)
            .navigationTitle(drawing.title ?? "Untitled")
            .toolbar {
                
            }
    }
}

struct DrawingCanvasView: UIViewRepresentable {
    
    var canvasView: PKCanvasView
    private let toolPicker = PKToolPicker()
    
    @Binding var drawing: Drawing
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.drawingPolicy = .anyInput
        self.canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        self.canvasView.becomeFirstResponder()
        if let drawing = try? PKDrawing(data: drawing.data ?? Data()) {
            canvasView.drawing = drawing
        }
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        self.toolPicker.addObserver(canvasView)
        self.toolPicker.setVisible(true, forFirstResponder: uiView)
        uiView.becomeFirstResponder()
    }
    
}


