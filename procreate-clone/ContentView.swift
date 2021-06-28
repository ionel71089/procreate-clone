//
//  ContentView.swift
//  procreate-clone
//
//  Created by Lescai, Ionel on 2021-06-28.
//

import SwiftUI

struct ContentView: View {
    @State var scale: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    @State private var angle: Double = 0
    @State private var lastAngle: Double = 0
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color("Menu"))
                    .frame(height: 50)
                
                HStack {
                    Text("Gallery")
                    
                    Spacer()
                    
                    Label("Pallette", systemImage: "paintbrush")
                    Label("Measurement", systemImage: "circle.grid.cross")
                }
                .foregroundColor(.white)
                .padding()
            }.frame(height: 50)
            
            ZStack {
                Rectangle()
                    .fill(Color("Background"))
                
                Image("grid_tile")
                    .resizable(resizingMode: .tile)
                
                HStack(alignment: .center) {
                    IRScaleView()
                        .frame(width: 30, height: 420, alignment: .leading)
                    
                    Spacer()
                }
                
                ThermalImageView()
                    .frame(width: 800, height: 600)
                    .scaleEffect(scale)
                    .rotationEffect(Angle.degrees(angle))
                    .offset(x: offset.width, y: offset.height)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / self.lastScaleValue
                                self.lastScaleValue = value
                                scale = self.scale * delta
                            }.onEnded{ _ in
                                lastScaleValue = 1
                            }
                    )
            }
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        offset = CGSize(width: lastOffset.width + gesture.translation.width,
                                        height: lastOffset.height + gesture.translation.height)
                    }
                    .onEnded { _ in
                        lastOffset = offset
                    }
            )
            .gesture(
                RotationGesture()
                    .onChanged { angle in
                        self.angle = lastAngle + angle.degrees
                    }
                    .onEnded { _ in
                        lastAngle = angle
                    }
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1024, height: 768))
    }
}


