//
//  EditRaidView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 02.12.2024.
//

import SwiftUI

struct EditRaidView: View {
    @EnvironmentObject var newConf: CalcManager
    
    @Binding var raidItem: RaidItem?
    @Binding var raidSystems: [RaidItem]
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var diskCount: String = ""
    @State private var capacity: String = ""
    
    @State private var raidLevel: String = "Не выбран"
    @State private var selectedRaidLevel: RaidLevel? = nil
    @State private var selectedDriveType: Int = 1
    
    // Для отображения списка рейдов
    var raidNames: [String] {
        newConf.raidLevels.map { $0.name }
    }
    
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading){
                MyPickerView(title: "Уровень RAID", selection: $raidLevel, options: raidNames)
                    .onChange(of: raidLevel) { _, newValue in
                        updateSelectedRaidLevel(for: newValue)
                    }
                    .pickerStyle(MenuPickerStyle()) // Стилизация пикера
                Text("Минимум дисков  \(selectedRaidLevel?.minDrives ?? 0)")
                Text("Максимум дисков \(selectedRaidLevel?.maxDrives ?? 0)")
                Text("Избыточность    \(selectedRaidLevel?.countDrivesRedundancy ?? 0)")
                
                
                
                Form {
                    Picker(selection: $selectedDriveType, label: Text("")) {
                        Text("HDD").tag(1)
                        Text("SSD").tag(2)
                    }.pickerStyle(.segmented)
//                        .onChange(of: selectedDriveType) { _, newValue in
//                            //newConf.system.systemType = (newValue == 2)
//                        }
                    
                    
                    TextField("Количество дисков", text: $diskCount)
                    // .keyboardType(.numberPad)
                    TextField("Емкость (ТБ)", text: $capacity)
                    // .keyboardType(.numberPad)
                    //TextField("Уровень RAID", text: $raidLevel)
                    
                    
                    
                }
                
                
                
                
            }
            
            
            .navigationTitle(raidItem == nil ? "Добавить RAID" : "Изменить RAID")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        let newRaidSystem = RaidItem(
                            id: raidItem?.id ?? UUID(),
                            diskCount: Int(diskCount) ?? 0,
                            capacity: Int(capacity) ?? 0,
                            driveType: selectedDriveType,
                            raidLevel: RaidLevel(name: raidLevel)
                        )
                        
                        if let index = raidSystems.firstIndex(where: { $0.id == raidItem?.id }) {
                            raidSystems[index] = newRaidSystem
                        } else {
                            raidSystems.append(newRaidSystem)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .padding()
        .onAppear {
            if let raidSystem = raidItem {
                diskCount = String(raidSystem.driveCount)
                capacity = String(raidSystem.capacity)
                raidLevel = raidSystem.raidLevel.name
            }
        }
        
    }
    private func updateSelectedRaidLevel(for name: String) {
        selectedRaidLevel =  newConf.raidLevels.first { $0.name == name }
    }
}

//#Preview {
//    EditRaidView()
//}
