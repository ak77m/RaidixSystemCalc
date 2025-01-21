//
//  SanView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 03.12.2024.
//

import SwiftUI

struct SanView: View {
    @EnvironmentObject var newConf: CalcManager
    
    //    @State private var selectedIscsiAdapter = "Пусто"
    //    @State private var selectedIserAdapter = "Пусто"
    //    @State private var selectedFcAdapter = "Пусто"
    //    @State private var selectedSrpAdapter = "Пусто"
    var body: some View {
        VStack{
            Toggle(isOn: $newConf.system.sanFunctionality) {
                Text(newConf.system.description(for: "sanFunctionality"))
                    .font(.headline)
            }.tint(.blue)
            
            VStack {
                if newConf.system.sanFunctionality {
                    
                    VStack(alignment: .leading){
                        
                        // iSCSI
                        Toggle(isOn: $newConf.system.iscsiProtocol) {
                            Text(newConf.system.description(for: "iscsiProtocol"))
                        }
                        if newConf.system.iscsiProtocol {
                            MyPickerView(title: newConf.system.description(for: "iscsiAdapter") ,
                                         selection: $newConf.system.iscsiAdapter,
                                         arrayForSelect: newConf.iscsi).padding(.leading)
                        }
                        
                        // iSER
                        Toggle(isOn: $newConf.system.iserProtocol) {
                            Text(newConf.system.description(for: "iserProtocol"))
                        }
                        if newConf.system.iserProtocol {
                            MyPickerView(title: newConf.system.description(for: "iserAdapter") ,
                                         selection: $newConf.system.iserAdapter,
                                         arrayForSelect: newConf.iser).padding(.leading)
                        }
                        
                        // FC
                        Toggle(isOn: $newConf.system.fcProtocol) {
                            Text(newConf.system.description(for: "fcProtocol"))
                        }
                        if newConf.system.fcProtocol {
                            MyPickerView(title: newConf.system.description(for: "fcAdapter") ,
                                         selection: $newConf.system.fcAdapter,
                                         arrayForSelect: newConf.fc).padding(.leading)
                        }
                        
                        
                        // SRP
                        Toggle(isOn: $newConf.system.srpProtocol) {
                            Text(newConf.system.description(for: "srpProtocol"))
                        }
                        if newConf.system.srpProtocol {
                            MyPickerView(title: newConf.system.description(for: "srpAdapter") ,
                                         selection: $newConf.system.srpAdapter,
                                         arrayForSelect: newConf.srp).padding(.leading)
                        }
                        
                        
                    }
                }
            }
            .padding(.leading)
        }.padding(.vertical, 5)
    }
}

#Preview {
    SanView().environmentObject(CalcManager())
}
