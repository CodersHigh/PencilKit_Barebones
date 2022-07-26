//
//  AddCanvasView.swift
//  PencilKit_Barebones
//
//  Created by 이로운 on 2022/07/26.
//

import SwiftUI

struct AddCanvasView: View {
    
    @Environment (\.managedObjectContext) var viewContext
    @Environment (\.presentationMode) var presentationMode
    
    @State private var canvasTitle = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("여기에 새로운 그림의 제목을 입력하세요.", text: $canvasTitle)
                }
            }
            .padding(.top, 10)
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationTitle(Text("새로운 그림"))
            .navigationBarItems(leading: Button("취소") {
                self.presentationMode.wrappedValue.dismiss()
            }, trailing: Button("저장") {
                if !canvasTitle.isEmpty {
                    let drawing = Drawing(context: viewContext)
                    drawing.title = canvasTitle
                    drawing.id = UUID()
                    
                    do {
                        try viewContext.save()
                    } catch {
                        print(error)
                    }
                    
                    self.presentationMode.wrappedValue.dismiss()
                }}
                .disabled(canvasTitle.isEmpty)
            )
        }
    }
}

struct AddCanvasView__Previews: PreviewProvider {
    static var previews: some View {
        AddCanvasView()
    }
}
