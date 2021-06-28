//
//  ContentView.swift
//  procreate-clone
//
//  Created by Lescai, Ionel on 2021-06-28.
//

import SwiftUI

struct ContentView: View {
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
                
                HStack(alignment: .center) {
                    Rectangle()
                        .fill(Color.black)
                        .frame(width: 50, height: 420, alignment: .leading)
                    
                    Spacer()
                }
                
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 800, height: 600)
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
