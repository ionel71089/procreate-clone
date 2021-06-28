//
//  ThermalImageView.swift
//  procreate-clone
//
//  Created by Anuta, Cosmin on 2021-06-28.
//

import SwiftUI

struct ThermalImageView: View {
    @State
    private var revealValue: CGFloat = 0.0
    
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
            }
            .gesture(DragGesture()
                        .onChanged { value in
                            revealValue = max(0, min(1, (value.startLocation.x + value.translation.width) / geo.size.width))
                        })
        }
    }
}

struct ThermalImageView_Previews: PreviewProvider {
    static var previews: some View {
        ThermalImageView()
    }
}
