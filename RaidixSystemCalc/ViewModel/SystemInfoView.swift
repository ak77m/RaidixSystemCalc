//
//  SystemInfoView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 29.11.2024.
//

import SwiftUI
import SwiftData

struct SystemInfoView: View {
    @EnvironmentObject var newConf: CalcManager
    
    var body: some View {
        
        VStack(alignment: .leading){
            
            // Выбор типа системы
            Picker(selection: $newConf.system.systemType, label: Text("")) {
                Text("(SC) один контроллер").tag(false)
                Text("(DC) два контроллера").tag(true)
            }.pickerStyle(.segmented)
            
            
            // Выбор протокола синхронизации и адаптера
            SynchroView()
            
            // SAN
            SanView ()
            
            
            // NAS
            NasView()
            
            // CacheView
            CacheView()
            
            // HBA
            MyPickerView(title: newConf.system.description(for: "hbaAdapter"),
                         selection: $newConf.system.hbaAdapter,
                         arrayForSelect: newConf.sas)
            .font(.headline)
            .navigationTitle("Система")
            
            Spacer()
            
            NavigationLink(destination: FinalInfoView()) {
                Text("Результат")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(!(newConf.system.sanFunctionality || newConf.system.nasFunctionality) ? Color.gray : Color.blue)
                    
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!(newConf.system.sanFunctionality || newConf.system.nasFunctionality))
        }.padding()
        
    }
    
    
}

#Preview {
    SystemInfoView().environmentObject(CalcManager())
    
}
