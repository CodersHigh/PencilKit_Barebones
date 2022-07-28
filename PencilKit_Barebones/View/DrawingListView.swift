//
//  ContentView.swift
//  PencilKit_Barebones
//
//  Created by 이로운 on 2022/07/26.
//

import SwiftUI
import CoreData

struct DrawingListView: View {
    @StateObject var viewModel = DrawingViewModel()
    @State private var showingSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.drawings, id: \.self) { drawing in
                    // 셀을 누를 시, 해당 드로잉 편집 화면으로 이동
                    NavigationLink(destination: DrawingView(viewModel: viewModel, drawing: drawing)) {
                        Text(drawing.title ?? "untitled")
                    }
                }
                // 셀을 스와이프할 시, 해당 드로잉 삭제
                .onDelete { indexSet in
                    indexSet.forEach { index in
                        let drawing = viewModel.drawings[index]
                        viewModel.deleteDrawing(drawing: drawing)
                        viewModel.fetchDrawing()
                    }
                }
                // <+ 새로운 그림> 버튼 눌렀을 때 AddCanvasView로 이동
                Button {
                    self.showingSheet.toggle()
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("새로운 그림")
                    }
                }
                .foregroundColor(.blue)
                .sheet(isPresented: $showingSheet) {
                    AddCanvasView(viewModel: viewModel)
                }
            }
            .navigationTitle(Text("그림들"))
            
            // 아이패드에서만 표시되는 부분
            VStack {
                Image(systemName: "scribble.variable")
                    .font(.largeTitle)
                Text("캔버스를 선택하고 그림을 그리세요!")
                    .font(.title)
            }
        }
        .onAppear {
            viewModel.fetchDrawing()
        }
    }
    
}
