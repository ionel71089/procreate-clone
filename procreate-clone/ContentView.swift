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
                    .rotationEffect(.degrees(Double(offset.width / 5)))
                    .offset(x: offset.width, y: offset.height)
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                let delta = value / self.lastScaleValue
                                self.lastScaleValue = value
                                scale = self.scale * delta
                            }.onEnded{val in
                                lastScaleValue = 1
                            })
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.offset = gesture.translation
                            }
                    )
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1024, height: 768))
    }
}
