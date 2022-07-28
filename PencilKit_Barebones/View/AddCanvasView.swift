//
//  AddCanvasView.swift
//  PencilKit_Barebones
//
//  Created by 이로운 on 2022/07/26.
//

import SwiftUI

struct AddCanvasView: View {
    @ObservedObject var viewModel: DrawingViewModel
    @Environment (\.presentationMode) var presentationMode
    @State private var canvasTitle = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("여기에 새로운 그림의 제목을 입력하세요.", text: $canvasTitle)
                }
            }
            .navigationTitle(Text("새로운 그림"))
            .toolbar {
                // 취소를 누르면 아무 작업도 하지 않고 뒤로 가기
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                // 저장을 누르면 입력한 제목의 드로잉을 생성하고 뒤로 가기
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("저장") {
                        viewModel.addDrawing(title: canvasTitle)
                        viewModel.fetchDrawing()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .disabled(canvasTitle.isEmpty)
                }
            }
        }
    }
}
