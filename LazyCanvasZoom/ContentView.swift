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
                            index: index,
                            isZooming: zoomState.isZooming,
                            currentScale: zoomState.scale
                        ))
                        .frame(width: 200 * zoomState.scale,
                               height: 200 * zoomState.scale)
                        .border(.gray)
                        .id("canvas_\(index)")
                    }
                }
            }
            .frame(height: 300)
            .border(.pink)
            .gesture(MagnificationGesture()
                .onChanged { scale in
                    zoomState.isZooming = true
                    zoomState.scale = scale
                }
                .onEnded { _ in
                    zoomState.isZooming = false
                    // Keep the current scale instead of resetting
                    // zoomState.scale = 1.0
                }
            )
        }
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
    let isZooming: Bool
    let currentScale: CGFloat
    
    static func == (lhs: SimpleCanvas, rhs: SimpleCanvas) -> Bool {
        if lhs.isZooming && rhs.isZooming {
            return true
        }
        return lhs.index == rhs.index &&
               lhs.isZooming == rhs.isZooming &&
               abs(lhs.currentScale - rhs.currentScale) < 0.001
    }
    
    var body: some View {
        Canvas { context, size in
            print("DRAWING CANVAS \(index)")
            
            let text = Text("\(index)").font(.system(size: 60))
            let position = CGPoint(x: size.width/2, y: size.height/2)
            
            // Scale the text relative to the zoom
            context.scaleBy(x: 1/currentScale, y: 1/currentScale)
            context.draw(text, at: CGPoint(
                x: position.x * currentScale,
                y: position.y * currentScale
            ))
        }
    }
}

class ZoomState: ObservableObject {
    @Published var isZooming: Bool = false
    @Published var scale: CGFloat = 1.0
}

#Preview {
    ContentView()
}
