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
    @State private var showingAlert = false
    
    var body: some View {
        DrawingCanvasView(canvasView: canvasView, drawing: $drawing)
            .navigationTitle(drawing.title ?? "Untitled")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack {
                        Button {
                            // 현재 canvasView 캡처해서 앨범에 저장
                        } label: {
                            Image(systemName: "camera")
                        }
                        .alert(isPresented: $showingAlert) {
                            Alert(title: Text("그림이 앨범에 저장되었습니다."))
                        }
                        Button {
                            // 현재 드로잉 진행 상황을 저장
                        } label: {
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                    .padding(.horizontal, 7)
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
        uiView.becomeFirstResponder()
    }
    
}


