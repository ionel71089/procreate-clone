//
//  ThermalImageViewModel.swift
//  procreate-clone
//
//  Created by Cosmin Anuta on 30.08.2021.
//

import Foundation
import ThermalSDK
import SwiftUI



class ThermalImageViewModel {
    let thermalImage = FLIRThermalImageFile()
    
    init(path: String) {
        thermalImage.open(path)
        thermalImage.getImage()
    }
    
    func dcImage() -> UIImage {
        thermalImage.getFusion()?.setFusionMode(VISUAL_MODE)
        return thermalImage.getImage()!
    }
    
    func irImage() -> UIImage {
        thermalImage.getFusion()?.setFusionMode(FUSION_MSX_MODE)
        return thermalImage.getImage()!
    }
}
