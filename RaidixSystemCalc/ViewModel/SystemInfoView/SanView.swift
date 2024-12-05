//
//  SanView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 03.12.2024.
//

import SwiftUI

struct SanView: View {
    @EnvironmentObject var newConf: CalcManager
    @State private var selectedSanAdapter: Int = 1
    @State private var selectedIscsiProtocol = "Пусто"
    
    var body: some View {
        
        Toggle(isOn: $newConf.system.sanFunctionality) {
            Text(newConf.system.description(for: "sanFunctionality"))
                .font(.headline)
        }
        
        if newConf.system.sanFunctionality {
            
            VStack(alignment: .leading){
                // iSCSI
                Toggle(isOn: $newConf.system.iscsiProtocol) {
                    Text(newConf.system.description(for: "iscsiProtocol"))
                }
                if newConf.system.iscsiProtocol {
                    MyPickerView(title: newConf.system.description(for: "iscsiAdapter") ,
                                 selection: $selectedIscsiProtocol,
                                 options: newConf.iscsi)
                }
                
                // iSER
                Toggle(isOn: $newConf.system.iserProtocol) {
                    Text(newConf.system.description(for: "iserProtocol"))
                }
                
                // FC
                Toggle(isOn: $newConf.system.fcProtocol) {
                    Text(newConf.system.description(for: "fcProtocol"))
                }
                
                
                // SRP
                Toggle(isOn: $newConf.system.srpProtocol) {
                    Text(newConf.system.description(for: "srpProtocol"))
                }
                
                
            }
            
            .padding(.leading)
        }
    }
}

#Preview {
    SanView().environmentObject(CalcManager())
}
