//
//  ThermalImageViewModel.swift
//  procreate-clone
//
//  Created by Cosmin Anuta on 30.08.2021.
//

import Foundation
import ThermalSDK
import SwiftUI
import Combine

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
    
    @Published var irScaleMin: CGFloat
    @Published var irScaleMax: CGFloat
    @Published var range: ClosedRange<CGFloat>
    
    private var disposeBag = Set<AnyCancellable>()
    
    init(path: String) {
        thermalImage.open(path)
        thermalImage.setTemperatureUnit(.CELSIUS)
        thermalImage.getImage()
        thermalImage.setTemperatureUnit(.CELSIUS)
        
        irScaleMin = CGFloat(thermalImage.getScale()!.getRangeMin().value)
        irScaleMax = CGFloat(thermalImage.getScale()!.getRangeMax().value)
        
        let cameraInfo = thermalImage.getCameraInformation()!
        range = CGFloat(cameraInfo.rangeMin.asCelsius().value) ... CGFloat(cameraInfo.rangeMax.asCelsius().value)
        
        updateImages()
        bind()
    }
    
    private func bind() {
        $irScaleMin
            .dropFirst()
            .throttle(for: 1, scheduler: RunLoop.main, latest: true)
            .sink { value in
            self.setScaleMin(value: Double(value))
        }.store(in: &disposeBag)

        $irScaleMax
            .dropFirst()
            .throttle(for: 1, scheduler: RunLoop.main, latest: true)
            .sink { value in
            self.setScaleMax(value: Double(value))
        }.store(in: &disposeBag)
    }
    
    private func updateImages() {
        print("update")
        thermalImage.getFusion()?.setFusionMode(FUSION_MSX_MODE)
        irImage = thermalImage.getImage()!
        let img = thermalImage.getScale()!.getImage()!
        scaleImage = img
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
    
    var imageSize: CGSize {
        let size = dcImage.size
        if size.width > size.height {
            return CGSize(width: 800, height: 600)
        } else {
            return CGSize(width: 600 * 0.6, height: 800 * 0.6)
        }
    }
}
