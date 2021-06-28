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
    @Binding var color: Color
    
    @State var shapes = [(lines:[CGPoint], color: Color)]()
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image("copacDC")
                    .resizable()
                Image("copacIR")
                    .resizable()
                    .mask(
                        HStack {
                            Rectangle()
                                .frame(width: revealValue * geo.size.width)
                            Spacer()
                        }
                    )
                
                ForEach((0..<shapes.count), id: \.self) { index in
                    Line(points: shapes[index].lines)
                        .stroke(lineWidth: 5)
                        .foregroundColor(shapes[index].color)
                }

            }
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isDrawing {
                            revealValue = max(0, min(1, (value.startLocation.x + value.translation.width) / geo.size.width))
                        } else {
                            let point = value.location
                            var (currentShape, _) = shapes.last!
                            if currentShape.isEmpty {
                                currentShape.append(value.startLocation)
                            }
                            
                            if !(currentShape.last == point) {
                                currentShape.append(point)
                                shapes[shapes.count - 1] = (currentShape, color)
                                print("Shapes: \(shapes)")
                            }
                        }
                    }
                    .onEnded { _ in
                        if isDrawing {
                            shapes.append((lines: [CGPoint](), color: .white))
                        }
                    }
            )
        }
        .onAppear {
            shapes.append((lines: [CGPoint](), color: .white))
        }
    }
}

struct ThermalImageView_Previews: PreviewProvider {
    static var previews: some View {
        ThermalImageView(revealValue: .constant(0.5), isDrawing: .constant(false), color: .constant(.black))
    }
}
