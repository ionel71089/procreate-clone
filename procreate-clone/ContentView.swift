//
//  ContentView.swift
//  procreate-clone
//
//  Created by Lescai, Ionel on 2021-06-28.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()
    @ObservedObject var imageViewModel = ThermalImageViewModel(path: Bundle.main.url(forResource: "sample5.jpg", withExtension: nil)!.path)
    
    @State var scale: CGFloat = 1.0
    @State var lastScaleValue: CGFloat = 1.0
    @State private var offset = CGSize.zero
    @State private var lastOffset = CGSize.zero
    @State private var angle: Double = 0
    @State private var lastAngle: Double = 0
    @State private var showingOverlaysPopover = false
    
    @State private var min: CGFloat = 2
    @State private var max: CGFloat = 5
    private var range: ClosedRange<CGFloat> = 0 ... 10
    
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Rectangle()
                    .fill(Color("Menu"))
                    .frame(height: 50)
                
                HStack {
                    Label("Gallery", systemImage: "photo.on.rectangle.angled")
                    
                    Spacer()
                    
                    Label("Overlays", systemImage: "square.stack.3d.down.right")
                        .padding(3)
                        .padding(.horizontal, 5)
                        .onTapGesture {
                            self.showingOverlaysPopover.toggle()
                        }
                        .popover(isPresented: $showingOverlaysPopover, content: {
                            OverlaysPopover(isAgendaVisible: $viewModel.isAgendaVisible, isLogoVisible: $viewModel.isLogoVisible)
                        })
                    
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
                            viewModel.isMasking = false
                        }
                    
                    Label("Mask", systemImage: "bandage")
                        .padding(3)
                        .padding(.horizontal, 5)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .fill(Color("Menu-Selected"))
                                .opacity(viewModel.isMasking ? 1.0 : 0.0)
                        )
                        .onTapGesture {
                            viewModel.isMasking.toggle()
                            viewModel.isDrawing = false
                        }
                    
                    Label("Pallette", systemImage: "paintbrush")
                        .padding(3)
                        .padding(.horizontal, 5)
                    
                    Label("Measurement", systemImage: "ruler")
                        .padding(3)
                        .padding(.horizontal, 5)
                    
                    Spacer()
                        .frame(width: 30)
                    
                    ColorPicker("", selection: $viewModel.color)
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
                        IRScaleView(
                            image: Image(uiImage: imageViewModel.scaleImage), 
                            min: $imageViewModel.irScaleMin,
                            max: $imageViewModel.irScaleMax,
                            range: $imageViewModel.range
                        )
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
                
                ThermalImageView(revealValue: $viewModel.revealValue, isDrawing: $viewModel.isDrawing, isMasking: $viewModel.isMasking, color: $viewModel.color, isLogoVisible: $viewModel.isLogoVisible, isAgendaVisible: $viewModel.isAgendaVisible)
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
        .statusBar(hidden: true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewLayout(.fixed(width: 1024, height: 768))
    }
}


