//
//  IRScaleView.swift
//  procreate-clone
//
//  Created by Anuta, Cosmin on 2021-06-28.
//

import SwiftUI

let thumbHeight: CGFloat = 20
let sliderOuterBackground = #colorLiteral(red: 0.1450980392, green: 0.1450980392, blue: 0.1450980392, alpha: 1)
let thumbColor = #colorLiteral(red: 0.5254901961, green: 0.5254901961, blue: 0.5254901961, alpha: 1)

struct IRScaleView: View {
    var image: Image
    @Binding var min: CGFloat
    @Binding var max: CGFloat
    @Binding var range: ClosedRange<CGFloat>
    
    var average: CGFloat {
        (min + max) / 2
    }
    
    func thumbSpacing(_ geo: GeometryProxy) -> CGFloat {
        0//ilerp(2 * thumbHeight + 30, min: 0, max: geo.size.height).lerp(range)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .top) {
                Color(sliderOuterBackground)
                                
                image
                    .resizable()
                
                Thumb()
                    .offset(y: geo.size.height * min.ilerp(range))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let y = value.startLocation.y + value.translation.height
                                min = clamp(ilerp(y, min: 0, max: geo.size.height).lerp(range), min: range.lowerBound, max: max - thumbSpacing(geo))
                            }
                    )
                
                DragIndicator()
                    .offset(y: geo.size.height  * average.ilerp(range) - thumbHeight / 2)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let y = value.startLocation.y + value.translation.height
                                let interval = max - min
                                let avg = clamp(ilerp(y, min: 0, max: geo.size.height).lerp(range), min: range.lowerBound + interval/2, max: range.upperBound - interval/2)
                                min = avg - interval/2
                                max = min + interval
                            }
                    )
                
                Thumb()
                    .offset(y: geo.size.height * max.ilerp(range) - thumbHeight)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                let y = value.startLocation.y + value.translation.height
                                max = clamp(ilerp(y, min: 0, max: geo.size.height).lerp(range), min: min + thumbSpacing(geo), max: range.upperBound)
                            }
                    )
                
            }
        }
    }
}

struct Thumb: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(Color(thumbColor))
            .frame(height: thumbHeight)
            .shadow(color: .black, radius: 1, x: 0, y: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white.opacity(0.6))
                    .shadow(color: .black, radius: -1, x: 0, y: 1)
            )
    }
}

struct DragIndicator: View {
    var body: some View {
        Image(systemName: "circle.grid.cross.fill")
            .foregroundColor(Color(thumbColor).opacity(0.4))
            .aspectRatio(contentMode: .fill)
            .frame(height: thumbHeight)
            .shadow(color: .white, radius: 1, x: 0, y: 2)
    }
}

struct IRScaleView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IRScaleView(
                image: Image("copacIRScale"), min: .constant(0), max: .constant(1), range: .constant(0...1)
            )
                .previewLayout(.fixed(width: 30.0, height: 420.0))            
            
            Thumb()
                .frame(width: 30)
                .previewLayout(.fixed(width: 100, height: 100))
            
            DragIndicator()
                .frame(width: 30)
                .previewLayout(.fixed(width: 100, height: 100))
        }
    }
}

extension Lerpable where Self: Comparable {
    func lerp(_ range: ClosedRange<Self>) -> Self {
        lerp(min: range.lowerBound, max: range.upperBound)
    }
    
    func ilerp(_ range: ClosedRange<Self>) -> Self {
        ilerp(min: range.lowerBound, max: range.upperBound)
    }
}
