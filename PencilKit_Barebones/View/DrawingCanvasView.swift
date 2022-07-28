//
//  DrawingCanvasView.swift
//  PencilKit_Barebones
//
//  Created by 이로운 on 2022/07/28.
//

import SwiftUI
import PencilKit

struct DrawingCanvasView: UIViewRepresentable {
    
    var canvasView: PKCanvasView
    private let toolPicker = PKToolPicker()
    
    @Binding var drawing: Drawing
    
    func makeUIView(context: Context) -> PKCanvasView {
        // PKCanvasView 세팅, drawing의 data를 불러와 캔버스에 띄우기
        self.canvasView.backgroundColor = UIColor.white
        self.canvasView.becomeFirstResponder()
        if let drawing = try? PKDrawing(data: drawing.data ?? Data()) {
            canvasView.drawing = drawing
        }
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // PKToolPicker 띄우기
        self.toolPicker.addObserver(canvasView)
        self.toolPicker.setVisible(true, forFirstResponder: uiView)
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }
}
