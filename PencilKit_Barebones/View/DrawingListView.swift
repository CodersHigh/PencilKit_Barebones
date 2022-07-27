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
                        AddCanvasView { title in
                            viewModel.addDrawing(title: title)
                            viewModel.fetchDrawing()
                        }
                    }
                }
                .navigationTitle(Text("그림들"))
            }
            VStack {
                Image(systemName: "scribble.variable")
                    .font(.largeTitle)
                Text("캔버스를 선택하고 그림을 그리세요!")
                    .font(.title)
            }
        }
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
    }
    
}
