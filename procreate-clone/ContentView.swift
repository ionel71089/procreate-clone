//
//  ContentView.swift
//  procreate-clone
//
//  Created by Lescai, Ionel on 2021-06-28.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    
    @State var scale: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    @State private var angle: Double = 0
    @State private var lastAngle: Double = 0
    
    @State private var color: Color = .white
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color("Menu"))
                    .frame(height: 50)
                
                HStack {
                    Label("Gallery", systemImage: "photo.on.rectangle.angled")
                    
                    Spacer()
                    
                    Label("Annotate", systemImage: "hand.draw")
                        .padding(3)
                        .padding(.horizontal, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color("Menu-Selected"))
                                .opacity(viewModel.isDrawing ? 1.0 : 0.0)
                        )
                        .onTapGesture {
                            viewModel.isDrawing.toggle()
                        }
                    
                    
                    Label("Pallette", systemImage: "paintbrush")
                        .padding(3)
                        .padding(.horizontal, 5)
                    
                    Label("Measurement", systemImage: "ruler")
                        .padding(3)
                        .padding(.horizontal, 5)
                    
                    Spacer()
                        .frame(width: 30)
                    
                    ColorPicker("", selection: $color)
                        .frame(width: 22)
                }
                .foregroundColor(.white)
                .padding()
            }.frame(height: 50)
            
            ZStack {
                Rectangle()
                    .fill(Color("Background"))
                
                Image("grid_tile")
                    .resizable(resizingMode: .tile)
                    .opacity(0.3)
                
                HStack {
                    VStack(alignment: .center) {
                        IRScaleView()
                            .frame(width: 30, height: 420, alignment: .leading)
                    

                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Color("Grid"), lineWidth: 2)
                                .frame(width: 20, height: 20)
                                .padding(.top, 15)
                                .onTapGesture {
                                    withAnimation {
                                        if viewModel.revealValue == 0 {
                                            viewModel.revealDC()
                                        } else {
                                            viewModel.hideDC()
                                        }
                                    }
                                }
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { value in
                                            withAnimation {
                                                viewModel.revealDC()
                                            }
                                        }
                                        .onEnded { value in
                                            withAnimation {
                                                viewModel.hideDC()
                                            }
                                    }
                                )
                        
                    }
                    .padding()
                    .background(Color("Menu"))
                    .foregroundColor(.white)
                    
                    Spacer()
                }
                
                ThermalImageView(revealValue: $viewModel.revealValue)
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


