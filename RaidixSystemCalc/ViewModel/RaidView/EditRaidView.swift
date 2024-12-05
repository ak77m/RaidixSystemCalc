//
//  EditRaidView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 02.12.2024.
//

import SwiftUI

//var id: UUID
//var driveCount: Int // Количество дисков в группе
//var capacity: Int // Емкость 1 диска
//var driveType: Int // 1 - HDD, 2 - SSD
//var raidLevel: RaidLevel

struct EditRaidView: View {
    @EnvironmentObject var newConf: CalcManager
    
    @Binding var raidItem: RaidItem? // Выбранный или создаваемый рейд. Передается из RaidView
    @Binding var raidSystems: [RaidItem]    // Передается из RaidView. Cписок рейдов
    @State private var selectedRaidLevel: RaidLevel? = nil  // Выбранный рейд
    
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var diskCount: Int = 0
    @State private var capacity: Double = 0.5
    
    @State private var raidLevel: String = "Пусто"
    
    @State private var selectedDriveType: Int = 1
    
    // Для отображения списка рейдов
    var raidNames: [String] {
        newConf.raidLevels.map { $0.name }
    }
    
    var minValue: Double {
        Double(selectedRaidLevel?.minDrives ?? 0)
    }

    var maxValue: Double {
        Double(selectedRaidLevel?.maxDrives ?? 1)
    }
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading){
                MyPickerView(title: "Уровень RAID", selection: $raidLevel, options: raidNames)
                    .onChange(of: raidLevel) { _, newValue in
                        updateSelectedRaidLevel(for: newValue)
                    }
                    .pickerStyle(MenuPickerStyle()) // Стилизация пикера
                
                Text("Минимум дисков  \(selectedRaidLevel?.minDrives ?? 0)").font(.footnote)
                Text("Максимум дисков \(selectedRaidLevel?.maxDrives ?? 0)").font(.footnote)
                Text("Избыточность    \(selectedRaidLevel?.countDrivesRedundancy ?? 0)").font(.footnote)
                
                
                
                Form {
                    Picker(selection: $selectedDriveType, label: Text("")) {
                        Text("HDD").tag(1)
                        Text("SSD").tag(2)
                    }.pickerStyle(.segmented)
//                        .onChange(of: selectedDriveType) { _, newValue in
//                            //newConf.system.systemType = (newValue == 2)
//                        }
                    
                    Text("Общая емкость RAID \(String(format: "%.1f", (capacity * Double(diskCount)))) Тб")
                 
                    // Отображаем и меняем количество дисков в рейде
                    Text("Дисков в RAID:  \(diskCount) шт.")
                    Slider(
                        value: Binding(
                            get: { Double(diskCount) },
                            set: { diskCount = Int($0) }
                        ),
                        in: minValue...maxValue,
                        step: 1
                    )
                    
                    .onChange(of: selectedRaidLevel) { _ , newValue in
                        diskCount = newConf.minMaxValueCorrection(newValue, count: diskCount)

                    }
                    
                    
                    // Отображаем и меняем емкость 1 диска
                    Text("Емкость 1 диска \(String(format: "%.1f", capacity)) Тб")
                    Slider(
                        value: $capacity,
                        in: 0.0...30.0,
                        step: 0.2
                    )
                   
                    
                
                  
                    
                }
                .disabled(maxValue < 64)
                
                
                
                
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
                            diskCount: diskCount,
                            capacity: Double(capacity),
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
                diskCount = raidSystem.driveCount
                capacity = Double(raidSystem.capacity)
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
