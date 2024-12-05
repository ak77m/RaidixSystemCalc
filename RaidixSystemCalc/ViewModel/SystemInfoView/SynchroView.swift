//
//  SynchroView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 02.12.2024.
//

import SwiftUI

struct SynchroView: View {
    @EnvironmentObject var newConf: CalcManager
    
    @State private var selectedSynhroProtocol: String = "iSCSI" // Промежуточное значение для Picker-a
    @State private var currentOptions: [String] = []  // Данные для второго Picker
    @State private var selectedAdapter: String = ""
    
    var body: some View {
        // Если система 2х контроллерная
        if newConf.system.systemType {
            VStack(alignment: .leading){
                
                // Выбираем протокол синхры
                MyPickerView(
                               title: newConf.system.description(for: "synchronization"),
                               selection: $selectedSynhroProtocol,
                               options: ["iSCSI", "iSER", "SRP" ]
                           )
                .onChange(of: selectedSynhroProtocol) { _, newValue in
                    updateOptions(for: newValue)
                }
  
                // Выбираем адаптер синхры
                MyPickerView(
                               title: newConf.system.description(for: "synchroAdapter"),
                               selection: $selectedAdapter,
                               options: currentOptions
                           )
                .onChange(of: selectedAdapter) { _, newValue in
                    newConf.system.synchroAdapter = newValue
                }

              
            }
            .padding(.leading)
            .onAppear {
                updateOptions(for: selectedSynhroProtocol)
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
           
           // Устанавливаем выбранный адаптер в первый элемент массива или пустую строку
           selectedAdapter = currentOptions.first ?? "Пусто"
       }
    
//    // Обновление массива данных для второго Picker
//       private func updateOptions(for protocolTag: Int) {
//           switch protocolTag {
//           case 1: currentOptions = newConf.iscsi
//           case 2: currentOptions = newConf.iser
//           case 3: currentOptions = newConf.srp
//           default: currentOptions = []
//           }
//           
//           // Устанавливаем выбранный адаптер в первый элемент массива или пустую строку
//           selectedAdapter = currentOptions.first ?? "Пусто"
//       }
  
}

#Preview {
    SynchroView().environmentObject(CalcManager())
}
