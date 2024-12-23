//
//  SynchroView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 02.12.2024.
//

import SwiftUI

struct SynchroView: View {
    @EnvironmentObject var newConf: CalcManager
    
    @State private var currentOptions: [String] = []  // Данные для второго Picker
    
    var body: some View {
        // Если система 2х контроллерная
        if newConf.system.systemType {
            VStack(alignment: .leading){
                
                // Выбираем протокол синхры
                MyPickerView(
                               title: newConf.system.description(for: "synchronization"),
                               selection: $newConf.system.synchronization,
                               arrayForSelect: ["iSCSI", "iSER", "SRP" ]
                           )
                .onChange(of: newConf.system.synchronization) { _, newValue in
                    updateOptions(for: newValue)
                    // Устанавливаем выбранный адаптер в первый элемент массива или пустую строку
                    newConf.system.synchroAdapter = currentOptions.first ?? "Пусто"
                }
  
                // Выбираем адаптер синхры
                MyPickerView(
                               title: newConf.system.description(for: "synchroAdapter"),
                               selection: $newConf.system.synchroAdapter,
                               arrayForSelect: currentOptions
                           )

              
            }
            .padding(.leading)
            .onAppear {
                updateOptions(for: newConf.system.synchronization)
                // Обновляем список адаптеров только если он пустой
               // if currentOptions == [] { updateOptions(for: newConf.system.synchronization) }
            }
        }
        
        
        
    }
    
    // Обновление массива данных для второго Picker
       private func updateOptions(for protocolTag: String) {
           switch protocolTag {
           case "iSCSI": currentOptions = newConf.iscsi
           case "iSER": currentOptions = newConf.iser
           case "SRP": currentOptions = newConf.srp
           default: currentOptions = []
           }
           
          
           
          
       }
    
 
}

#Preview {
    SynchroView().environmentObject(CalcManager())
}
