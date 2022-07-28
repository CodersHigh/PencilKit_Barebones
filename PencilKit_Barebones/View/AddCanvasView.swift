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
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle(Text("새로운 그림"))
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
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
