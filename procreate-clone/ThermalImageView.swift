//
//  ThermalImageView.swift
//  procreate-clone
//
//  Created by Anuta, Cosmin on 2021-06-28.
//

import SwiftUI

struct Line: Shape {
    let points: [CGPoint]
    
    func path(in rect: CGRect) -> Path {
        var points = self.points
        var path = Path()
        
        guard !points.isEmpty else { return path }
        
        path.move(to: points.remove(at: 0))
        path.addLines(points)
        
        return path
    }
}

struct ThermalImageView: View {
    @Binding var revealValue: CGFloat
    @Binding var isDrawing: Bool
    @Binding var isMasking: Bool
    @Binding var color: Color
    @Binding var isLogoVisible: Bool
    @Binding var isAgendaVisible: Bool
    
    @State private var agendaPosition: CGPoint?
    @State private var logoPostion: CGPoint?
    
    @State var shapes = [(lines:[CGPoint], color: Color)]()
    @State var masks = [(lines:[CGPoint], color: Color)]()
    
    var viewModel = ThermalImageViewModel(path: Bundle.main.url(forResource: "sample5.jpg", withExtension: nil)!.path)
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(uiImage: viewModel.dcImage)
                    .resizable()
                Image(uiImage: viewModel.irImage)
                    .resizable()
                    .mask(
                        ZStack {
                            HStack {
                                Rectangle()
                                    .frame(width: revealValue * geo.size.width)
                                Spacer()
                            }
                            
                        }
                    )
                
                Image(uiImage: viewModel.dcImage)
                    .resizable()
                    .mask(
                        ForEach((0..<masks.count), id: \.self) { index in
                            Line(points: masks[index].lines)
                                .stroke(lineWidth: 30)
                                .foregroundColor(.red)
                        }
                    )
                
                ForEach((0..<shapes.count), id: \.self) { index in
                    Line(points: shapes[index].lines)
                        .stroke(lineWidth: 5)
                        .foregroundColor(shapes[index].color)
                }
                
                if isAgendaVisible {
                    Image("mobileAgenda")
                        .position(agendaPosition ?? CGPoint(x: 52, y: 56))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.agendaPosition = CGPoint(x: value.startLocation.x + value.translation.width, y: value.startLocation.y + value.translation.height)
                                }
                        )
                }
                if isLogoVisible {
                    Image("flirLogo")
                        .position(logoPostion ?? CGPoint(x: 50, y: geo.size.height - 28))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.logoPostion = CGPoint(x: value.startLocation.x + value.translation.width, y: value.startLocation.y + value.translation.height)
                                }
                        )
                }

            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isDrawing && !isMasking {
                            revealValue = max(0, min(1, (value.startLocation.x + value.translation.width) / geo.size.width))
                        } else if isDrawing {
                            let point = value.location
                            var (currentShape, _) = shapes.last!
                            if currentShape.isEmpty {
                                currentShape.append(value.startLocation)
                            }
                            
                            if !(currentShape.last == point) {
                                currentShape.append(point)
                                shapes[shapes.count - 1] = (currentShape, color)
                            }
                        } else if isMasking {
                            let point = value.location
                            var (currentShape, _) = masks.last!
                            if currentShape.isEmpty {
                                currentShape.append(value.startLocation)
                            }
                            
                            if !(currentShape.last == point) {
                                currentShape.append(point)
                                masks[masks.count - 1] = (currentShape, color)
                            }
                        }
                    }
                    .onEnded { _ in
                        if isDrawing {
                            shapes.append((lines: [CGPoint](), color: .white))
                        } else if isMasking {
                            masks.append((lines: [CGPoint](), color: .white))
                        }
                    }
            )
        }
        .onAppear {
            shapes.append((lines: [CGPoint](), color: .white))
            masks.append((lines: [CGPoint](), color: .white))
        }
    }
}

struct ThermalImageView_Previews: PreviewProvider {
    static var previews: some View {
        ThermalImageView(revealValue: .constant(0.5), isDrawing: .constant(false), isMasking: .constant(false), color: .constant(.black), isLogoVisible: .constant(true), isAgendaVisible: .constant(true))
    }
}
