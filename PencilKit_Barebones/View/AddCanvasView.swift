//
//  AddCanvasView.swift
//  PencilKit_Barebones
//
//  Created by 이로운 on 2022/07/26.
//

import SwiftUI

struct AddCanvasView: View {
    @Environment (\.presentationMode) var presentationMode
    @State private var canvasTitle = ""
    let onComplete: (String) -> Void
    
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
                onComplete(canvasTitle)
                self.presentationMode.wrappedValue.dismiss()
            }
            .disabled(canvasTitle.isEmpty))
        }
    }
}
