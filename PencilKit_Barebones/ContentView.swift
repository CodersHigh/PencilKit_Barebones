//
//  ContentView.swift
//  PencilKit_Barebones
//
//  Created by 이로운 on 2022/07/26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: Drawing.entity(), sortDescriptors: []) var drawings: FetchedResults<Drawing>
    
    @State private var showingSheet = false
    

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(drawings) { drawing in
                        Text(drawing.title ?? "Untitled")
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
                        AddCanvasView().environment(\.managedObjectContext, viewContext)
                    }
                }
                .navigationTitle(Text("그림들"))
                .toolbar {
                    EditButton()
                }
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
