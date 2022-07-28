//
//  DrawingView.swift
//  PencilKit_Barebones
//
//  Created by 이로운 on 2022/07/26.
//

import SwiftUI
import PencilKit

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
                // 툴바 오른쪽엔 그림 캡처 및 저장 버튼 배치
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    HStack(spacing: 10) {
                        // 현재 canvasView 캡처해서 앨범에 저장하는 버튼
                        Button {
                            let image = canvasView.drawing.image(from: canvasView.drawing.bounds, scale: 1)
                            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
                        } label: {
                            Image(systemName: "camera")
                        }
                        // 현재 드로잉 진행 상황을 저장하는 버튼
                        Button {
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
                // 툴바 왼쪽엔 실행 취소, 다시 실행, 모두 지우기 버튼 배치
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    HStack(spacing: 10) {
                        // 실행 취소 버튼
                        Button {
                            undoManager?.undo()
                        } label: {
                            Image(systemName: "arrow.uturn.backward.circle")
                        }
                        // 다시 실행 버튼
                        Button {
                            undoManager?.redo()
                        } label: {
                            Image(systemName: "arrow.uturn.forward.circle")
                        }
                        // 모두 지우기 버튼
                        Button {
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


