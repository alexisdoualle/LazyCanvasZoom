//
//  ContentView.swift
//  LazyCanvasZoom
//
//  Created by Alexis Doualle on 19/12/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var zoomState = ZoomState()
    let numberOfItems = 20
    
    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(0..<numberOfItems, id: \.self) { index in
                        EquatableCanvasWrapper(content: SimpleCanvas(
                            index: index
                        ))
                        .frame(width: 200, height: 200) // Fixed base size
                        .scaleEffect(zoomState.scale) // Apply scale effect here
                        .border(.gray)
                        .id("canvas_\(index)")
                    }
                }
            }
            .frame(height: 300)
            .border(.pink)
        }
        .gesture(MagnificationGesture()
            .onChanged { scale in
                zoomState.scale = scale
            }
            .onEnded { _ in
                // Optional: Add any end-of-gesture logic here
            }
        )
    }
}

struct EquatableCanvasWrapper: View, Equatable {
    let content: SimpleCanvas
    
    static func == (lhs: EquatableCanvasWrapper, rhs: EquatableCanvasWrapper) -> Bool {
        lhs.content == rhs.content
    }
    
    var body: some View {
        content
            .drawingGroup()
    }
}

struct SimpleCanvas: View, Equatable {
    let index: Int
    
    static func == (lhs: SimpleCanvas, rhs: SimpleCanvas) -> Bool {
        lhs.index == rhs.index
    }
    
    var body: some View {
        Canvas { context, size in
            print("DRAWING CANVAS \(index), size \(size)")
            
            let text = Text("\(index)").font(.system(size: 60))
            let position = CGPoint(x: size.width/2, y: size.height/2)
            context.draw(text, at: position)
        }
    }
}

class ZoomState: ObservableObject {
    @Published var scale: CGFloat = 1.0
}

#Preview {
    ContentView()
}
