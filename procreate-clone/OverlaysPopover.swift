//
//  OverlaysPopover.swift
//  procreate-clone
//
//  Created by Cosmin Anuta on 30.08.2021.
//

import SwiftUI

struct VisibilityToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            Image(systemName: configuration.isOn ? "eye" : "eye.slash")
                .onTapGesture { configuration.isOn.toggle() }
        }
    }
}

struct OverlaysPopover: View {
    @Binding var isAgendaVisible: Bool
    @Binding var isLogoVisible: Bool
    
    var body: some View {
        VStack {
            Toggle(isOn: $isLogoVisible, label: {
                Text("FLIR Logo")
            })
            .padding()
            .toggleStyle(VisibilityToggleStyle())
            
            Toggle(isOn: $isAgendaVisible, label: {
                Text("Thermal Agenda")
            })
            .padding()
            .toggleStyle(VisibilityToggleStyle())
        }
        .foregroundColor(.black)
    }
}

struct OverlaysPopover_Previews: PreviewProvider {
    static var previews: some View {
        
        
        
        OverlaysPopover(isAgendaVisible: .constant(true), isLogoVisible: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
