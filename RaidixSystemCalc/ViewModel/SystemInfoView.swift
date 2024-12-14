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
   
  //  @State private var selectedSystemType: Int = 1 // Промежуточное значение для Picker-a
    @State private var selectedSsdCache: String = "Нет" // Промежуточное значение для Picker-a
  //  @State private var selectedSasAdapter: String = "Нет" // Промежуточное значение для Picker-a
    
    //@State private var selectedNasAdapter: Int = 1 // Промежуточное значение для Picker-a
    
    var body: some View {
       
            VStack(alignment: .leading){
                
                // Выбор типа системы
                Picker(selection: $newConf.system.systemType, label: Text("")) {
                    Text("Один контроллер").tag(false)
                    Text("Два контроллера").tag(true)
                }.pickerStyle(.segmented)

                
                // Выбор протокола синхронизации и адаптера
                SynchroView()
                
                // SAN
                SanView ()
                
                
                // NAS
                NasView()

               // CacheView
                MyPickerView(title: newConf.system.description(for: "ssdCache"),
                             selection: $selectedSsdCache,
                             arrayForSelect: ["Нет", "На 1 ноде", "На 2х нодах" ])
                    .font(.headline)
                
                // HBA
                MyPickerView(title: newConf.system.description(for: "hbaAdapter"),
                             selection: $newConf.system.hbaAdapter,
                             arrayForSelect: newConf.sas)
                    .font(.headline)
                
           Spacer()
        }.padding()
        
    }

  
}

#Preview {
    SystemInfoView().environmentObject(CalcManager())
       
}
