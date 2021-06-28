//
//  ViewModel.swift
//  procreate-clone
//
//  Created by Lescai, Ionel on 2021-06-28.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published var revealValue: CGFloat = 1.0
    @Published var isDrawing = false
    @Published var color: Color = .white
    @Published var isMasking = false
    
    func revealDC() {
        revealValue = 1
    }
    
    func hideDC() {
        revealValue = 0
    }
}
