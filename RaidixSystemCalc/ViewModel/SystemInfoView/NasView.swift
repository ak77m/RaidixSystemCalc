//
//  NasView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 02.12.2024.
//

import SwiftUI

struct NasView: View {
    @EnvironmentObject var newConf: CalcManager
    @State private var selectedNasAdapter: String = "Пусто"  // значение для Picker-a
    
    var body: some View {
        // NAS
        VStack {
            Toggle(isOn: $newConf.system.nasFunctionality) {
                Text(newConf.system.description(for: "nasFunctionality"))
                    .font(.headline)
            }
            
            if newConf.system.nasFunctionality {
                
                MyPickerView(
                    title: newConf.system.description(for: "ethAdapter"),
                    selection: $selectedNasAdapter,
                    arrayForSelect: newConf.iscsi  // адаптеры одинаковы
                )
                .onChange(of: selectedNasAdapter) { _, newValue in
                    newConf.system.ethAdapter = newValue
                }.padding(.leading)
                
            }
        }
    }
}

#Preview {
    NasView().environmentObject(CalcManager())
}
