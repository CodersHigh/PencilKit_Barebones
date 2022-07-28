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
            VStack {
                List {
                    ForEach(viewModel.drawings, id: \.self) { drawing in
                        NavigationLink(destination: DrawingView(viewModel: viewModel, drawing: drawing)) {
                            Text(drawing.title ?? "untitled")
                        }
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let drawing = viewModel.drawings[index]
                            viewModel.deleteDrawing(drawing: drawing)
                            viewModel.fetchDrawing()
                        }
                    }
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
            }
            VStack { // 아이패드에서만 표시되는 부분
                Image(systemName: "scribble.variable")
                    .font(.largeTitle)
                Text("캔버스를 선택하고 그림을 그리세요!")
                    .font(.title)
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .onAppear {
            viewModel.fetchDrawing()
        }
    }
    
}
