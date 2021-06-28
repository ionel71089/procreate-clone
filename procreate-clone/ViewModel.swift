//
//  ViewModel.swift
//  procreate-clone
//
//  Created by Lescai, Ionel on 2021-06-28.
//

import SwiftUI

class ViewModel: ObservableObject {
    @Published
    var revealValue: CGFloat = 0.0
    
    @Published
    var isDrawing = false
}
