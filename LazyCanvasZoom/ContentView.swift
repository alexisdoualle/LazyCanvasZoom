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
            // Debug info
            Text("Scale: \(zoomState.scale, specifier: "%.2f"), Scaled size: \((200 * zoomState.scale), specifier: "%.1f")")
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 0) {
                    ForEach(0..<numberOfItems, id: \.self) { index in
                        SimpleCanvas(index: index)
                        .frame(width: 200, height: 200)
                        .scaleEffect(zoomState.scale)
                        .border(.gray)
                        .id("canvas_\(index)")
                        .overlay(
                            // Move debug info to overlay
                            Text("Scale: \(zoomState.scale, specifier: "%.2f")")
                                .font(.system(size: 8))
                                .position(x: 100, y: 10)
                        )
                    }
                }
            }
            .frame(height: 300)
            .border(.pink)
            .gesture(MagnificationGesture()
                .onChanged { scale in
                    zoomState.scale = scale
                    // Debug print outside the canvas
//                    print("Current scale: \(scale), Scaled size: \(200 * scale)")
                }
            )
        }
    }
}

struct SimpleCanvas: View, Equatable {
    let index: Int
    private let baseFontSize: CGFloat = 60
    
    static func == (lhs: SimpleCanvas, rhs: SimpleCanvas) -> Bool {
        lhs.index == rhs.index
    }
    
    var body: some View {
        Canvas { context, size in
            print("DRAWING CANVAS \(index), size: \(size)")
            let rect = CGRect(x: 50, y: 50, width: 200, height: 100)
            let path = Path(rect)
            
            // Set the fill color to blue
            context.fill(path, with: .color(.blue))
            
            // Add a black stroke around the rectangle
            context.stroke(path, with: .color(.black), lineWidth: 2)
        }
    }
}

class ZoomState: ObservableObject {
    @Published var scale: CGFloat = 1.0
}

#Preview {
    ContentView()
}
