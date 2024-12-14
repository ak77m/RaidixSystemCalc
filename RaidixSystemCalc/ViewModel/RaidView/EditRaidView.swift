//
//  EditRaidView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 02.12.2024.
//

import SwiftUI

//var raidLevel: RaidLevel

struct EditRaidView: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var newConf: CalcManager
    
    @Binding var raidItem: RaidItem // Выбранный или создаваемый рейд. Передается из RaidView
    
    
    // Для отображения списка рейдов
    var raidNames: [String] {
        newConf.raidLevels.map { $0.name }
    }

    var minValue: Double {
        Double(raidItem.raidLevel.minDrives)
    }

    var maxValue: Double {
        Double(raidItem.raidLevel.maxDrives) // не = 0 иначе Slider вывалится с ошибкой
    }
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading){
                MyPickerView(title: "Уровень RAID", selection: $raidItem.raidLevel.name, arrayForSelect: raidNames)
                    .onChange(of: raidItem.raidLevel.name) { _, newValue in
                        updateSelectedRaidLevel(for: newValue)
                       
                    }
                    
                    .pickerStyle(MenuPickerStyle()) // Стилизация пикера
                
                Text("Минимум дисков  \(raidItem.raidLevel.minDrives)").font(.footnote)
                Text("Максимум дисков \(raidItem.raidLevel.maxDrives)").font(.footnote)
                Text("Избыточность    \(raidItem.raidLevel.countDrivesRedundancy)").font(.footnote)
                
                Divider()

                Text("Общая емкость RAID \(String(format: "%.1f", raidItem.totalCapacity)) Тб")
                Text("Емкость под данные \(String(format: "%.1f", raidItem.effectiveCapacity)) Тб").font(.footnote)
                Text("Диски под данные  \(raidItem.driveForData) шт").font(.footnote)
                
                Form {
                    Picker(selection: $raidItem.driveType, label: Text("")) {
                        Text("HDD").tag("HDD")
                        Text("SSD").tag("SSD")
                    }.pickerStyle(.segmented)
                                   .background(raidItem.raidEngineIsOptimal ? Color(.systemBackground) : Color.red)
                                   .cornerRadius(8) // Закругленные углы для более приятного вида
                                   .animation(.easeInOut, value: !raidItem.raidEngineIsOptimal) // Анимация изменения цвета
                    
                    
                    //    .background(raidItem.raidEngineIsOptimal ? . : .red)
                    //.foregroundColor(raidItem.raidEngineIsOptimal ? .primary : .red )
                    
                    // Отображаем и меняем количество дисков в рейде
                    Text("Дисков в RAID:  \(raidItem.driveCount) шт.").font(.footnote)
                    Slider(
                        value: Binding(
                            get: { Double(raidItem.driveCount) },
                            set: { raidItem.driveCount = Int($0) }
                        ),
                        in: minValue...maxValue,
                        step: 1
                    )
                    
                    .onChange(of: raidItem.raidLevel) { _ , newValue in
                        raidItem.driveCount = newConf.minMaxValueCorrection(newValue, count: raidItem.driveCount)

                    }
                    
                    
                    // Отображаем и меняем емкость 1 диска
                    Text("Емкость 1 диска \(String(format: "%.1f", raidItem.capacity)) Тб")
                    Slider(
                        value: Binding(
                              get: { raidItem.capacity},
                              set: { newValue in
                                  raidItem.capacity = newValue
                              }
                              ),
                        in: 0.0...30.0,
                        step: 0.2
                    )
                }
                
                Button(action: {
                    // Дублируем рейд, но с новым UUID
                    var NewItemindex = raidItem
                    NewItemindex.id = UUID()
                    newConf.saveRaidItem(NewItemindex)
                    
                }) {
                    Label("Дублировать RAID", systemImage: "plus")
                }
               
                .disabled(maxValue < 64)
            }.padding(.horizontal)
            
            .navigationTitle("Добавить/изменить RAID")
            //.navigationTitle(raidItem == nil ? "Добавить RAID" : "Изменить RAID")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        newConf.saveRaidItem(raidItem)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .padding(.horizontal)
        .onAppear {
           // raidLevelName = raidItem.raidLevel.name
        }
        //.frame(minWidth: 500, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        
    }
    private func updateSelectedRaidLevel(for name: String) {
        raidItem.raidLevel =  newConf.raidLevels.first { $0.name == name } ?? RaidLevel()
        raidItem.driveType = raidItem.raidLevel.raidEngine ? "SSD" : "HDD"
        //raidItem.raidLevel = selectedRaidLevel ?? RaidLevel()
        
    }
}

//#Preview {b
//    EditRaidView()
//}
