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
   
    @State private var selectedSystemType: Int = 1 // Промежуточное значение для Picker-a
    @State private var selectedSsdCache: String = "Нет" // Промежуточное значение для Picker-a
  
    //@State private var selectedNasAdapter: Int = 1 // Промежуточное значение для Picker-a
    
    var body: some View {
       
            VStack(alignment: .leading){
                
                Picker(selection: $selectedSystemType, label: Text("")) {
                    Text("Один контроллер").tag(1)
                    Text("Два контроллера").tag(2)
                    
                }.pickerStyle(.segmented)
                    .onChange(of: selectedSystemType) { _, newValue in
                        newConf.system.systemType = (newValue == 2)
                    }
                // Выбор протокола синхронизации и адаптера
                SynchroView()
                
                // SAN
                SanView ()
                
                
                // NAS
                NasView()

               // CacheView
                MyPickerView(title: newConf.system.description(for: "ssdCache"), selection: $selectedSsdCache, options: ["Нет", "На 1 ноде", "На 2х нодах" ])
                
           Spacer()
        }.padding()
        
    }

  
}

#Preview {
    SystemInfoView().environmentObject(CalcManager())
       
}
