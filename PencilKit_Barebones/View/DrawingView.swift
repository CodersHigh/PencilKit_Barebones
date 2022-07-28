//
//  DrawingView.swift
//  PencilKit_Barebones
//
//  Created by 이로운 on 2022/07/26.
//

import SwiftUI
import CoreData
import PencilKit
import Photos

struct DrawingView: View {
    @ObservedObject var viewModel: DrawingViewModel
    @Environment(\.undoManager) private var undoManager
    @State var drawing: Drawing
    @State private var canvasView = PKCanvasView()
    @State private var showingAlert = false
    
    var body: some View {
        DrawingCanvasView(canvasView: canvasView, drawing: $drawing)
            .navigationTitle(drawing.title ?? "Untitled")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack(spacing: 10) {
                        Button {
                            // 현재 canvasView 캡처해서 앨범에 저장
                            let image = canvasView.drawing.image(from: canvasView.drawing.bounds, scale: 1)
                            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                        } label: {
                            Image(systemName: "camera")
                        }
                        Button {
                            // 현재 드로잉 진행 상황을 저장
                            drawing.data = canvasView.drawing.dataRepresentation()
                            viewModel.saveContext()
                            showingAlert = true
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("그리기 진행 상황이 저장되었습니다."))
                        }
                    }
                }
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HStack(spacing: 10) {
                        Button { // undo
                            undoManager?.undo()
                        } label: {
                            Image(systemName: "arrow.uturn.backward.circle")
                        }
                        Button { // redo
                            undoManager?.redo()
                        } label: {
                            Image(systemName: "arrow.uturn.forward.circle")
                        }
                        Button { // clear
                            canvasView.drawing = PKDrawing()
                        } label: {
                            Image(systemName: "trash.circle")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
    }
}

struct DrawingCanvasView: UIViewRepresentable {
    
    var canvasView: PKCanvasView
    private let toolPicker = PKToolPicker.init()
    
    @Binding var drawing: Drawing
    
    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.tool = PKInkingTool(.pen, color: .black, width: 15)
        self.canvasView.backgroundColor = UIColor.white
        self.canvasView.becomeFirstResponder()
        if let drawing = try? PKDrawing(data: drawing.data ?? Data()) {
            canvasView.drawing = drawing
        }
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        self.toolPicker.addObserver(canvasView)
        self.toolPicker.setVisible(true, forFirstResponder: uiView)
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }
    
}


