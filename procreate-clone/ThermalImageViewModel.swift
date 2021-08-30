//
//  ThermalImageViewModel.swift
//  procreate-clone
//
//  Created by Cosmin Anuta on 30.08.2021.
//

import Foundation
import ThermalSDK
import SwiftUI

class ThermalImageViewModel: ObservableObject {
    private let thermalImage = FLIRThermalImageFile()
    
    @Published var dcImage: UIImage
    @Published var irImage: UIImage
    
    init(path: String) {
        thermalImage.open(path)
        thermalImage.getImage()
        thermalImage.getFusion()?.setFusionMode(FUSION_MSX_MODE)
        irImage = thermalImage.getImage()!
        thermalImage.getFusion()?.setFusionMode(VISUAL_MODE)
        dcImage = thermalImage.getImage()!
    }
    
    private func updateImages() {
        thermalImage.getFusion()?.setFusionMode(FUSION_MSX_MODE)
        irImage = thermalImage.getImage()!
        thermalImage.getFusion()?.setFusionMode(VISUAL_MODE)
        dcImage = thermalImage.getImage()!
    }
}
