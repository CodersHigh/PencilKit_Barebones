# PencilKit_Barebones
<br/>

### 프로젝트 소개
- PencilKit의 기본적인 기능 구현을 익히는 데에 도움을 주는 Bare-bones 프로젝트입니다.
- PencilKit을 통해 **SwiftUI 기반의 드로잉 앱**을 구현합니다.
- PencilKit을 처음 활용해 보는 경우, 이 프로젝트의 코드를 살펴보면 도움이 됩니다.



<br/>

### PencilKit이란?     
PencilKit은 **터치 또는 애플 펜슬의 입력을 그림으로 표시**해주는 프레임워크입니다.  
아이패드 사용자라면, 이런 드로잉 도구 모음을 이미 사용해 봤을 가능성이 큽니다.    
 
<img width="600" alt="PencilKitImage" src="https://user-images.githubusercontent.com/74223246/181435528-483d1d81-47dc-4437-a9bf-cd6f7177a74a.png">

PencilKit을 통해 이러한 **드로잉 도구 모음과 그림을 그릴 수 있는 캔버스**를 우리의 앱에서 제공할 수 있게 됩니다.     

몇 가지 중요한 요소들을 살펴봅시다. ⭐️      
- PKCanvasView : 그림을 그릴 수 있는 영역   
- PKToolPicker : 드로잉 툴(위의 이미지)   
- PKDrawing : 그려진 콘텐츠를 저장하는 객체   

더 자세한 내용이 궁금하다면 [Apple의 공식 문서](https://developer.apple.com/documentation/pencilkit)를 참고해 보세요.    

<br/>
<br/>

### 핵심 코드
드로잉 화면을 세팅하고 관련 기능들을 구현하는 핵심 코드를 참고하세요. 

<br/>

**드로잉 화면의 툴바**
```Swift
// 그림 캡처 및 저장 버튼의 ToolbarItemGroup
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
```
```Swift
// 실행 취소, 다시 실행, 모두 지우기 버튼의 ToolbarItemGroup
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
```

<br/>
<br/>

**PKCanvasView 및 PKToolPicker 세팅**
```Swift
struct DrawingCanvasView: UIViewRepresentable {
    var canvasView: PKCanvasView
    private let toolPicker = PKToolPicker()
    @Binding var drawing: Drawing
    
    // PKCanvasView 세팅, drawing의 data를 불러와 캔버스에 띄우기
    func makeUIView(context: Context) -> PKCanvasView {
        self.canvasView.backgroundColor = UIColor.white
        self.canvasView.becomeFirstResponder()
        if let drawing = try? PKDrawing(data: drawing.data ?? Data()) {
            canvasView.drawing = drawing
        }
        return canvasView
    }
    
    // PKToolPicker 띄우기
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        self.toolPicker.addObserver(canvasView)
        self.toolPicker.setVisible(true, forFirstResponder: uiView)
        DispatchQueue.main.async {
            uiView.becomeFirstResponder()
        }
    }
}
```
