//
//  ThermalImageViewModel.swift
//  procreate-clone
//
//  Created by Cosmin Anuta on 30.08.2021.
//

import Foundation
import ThermalSDK
import SwiftUI

struct Measurement: Identifiable {
    var id = UUID()
    var value: Double
    
    init(temperature: Double) {
        self.value = temperature
    }
}

class ThermalImageViewModel: ObservableObject {
    private let thermalImage = FLIRThermalImageFile()
    
    @Published var dcImage: UIImage!
    @Published var irImage: UIImage!
    @Published var scaleImage: UIImage!
    @Published var temperatures = [Measurement]()
    
    init(path: String) {
        thermalImage.open(path)
        thermalImage.setTemperatureUnit(.CELSIUS)
        thermalImage.getImage()
        updateImages()
    }
    
    private func updateImages() {
        thermalImage.getFusion()?.setFusionMode(FUSION_MSX_MODE)
        irImage = thermalImage.getImage()!
        scaleImage = thermalImage.getScale()!.getImage()!
        thermalImage.getFusion()?.setFusionMode(VISUAL_MODE)
        dcImage = thermalImage.getImage()!
        temperatures = thermalImage.measurements?.getAllSpots().map{ Measurement(temperature: $0.getValue().value) } ?? []
    }
    
    func setScaleMin(value: Double) {
        thermalImage.getScale()!.setRangeMin(FLIRThermalValue(value: value, andUnit: .CELSIUS))
        updateImages()
    }
    
    func setScaleMax(value: Double) {
        thermalImage.getScale()!.setRangeMax(FLIRThermalValue(value: value, andUnit: .CELSIUS))
        updateImages()
    }
}
