//
//  EditRaidView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 02.12.2024.
//

import SwiftUI

extension Color {
    static var platformBackground: Color {
        #if os(iOS)
        return Color(.systemBackground)
        #elseif os(macOS)
        return Color(.windowBackgroundColor)
        #endif
    }
}

struct EditRaidView: View {
   // @Environment(\.presentationMode) private var presentationMode
    @Environment(\.dismiss) private var dismiss
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
                Text("Избыточность    \(raidItem.raidLevel.evenNumber ? raidItem.driveCount / 2 : raidItem.raidLevel.countDrivesRedundancy)").font(.footnote)
                
                
                Divider()

                Text("Общая емкость RAID \(String(format: "%.1f", raidItem.totalCapacity)) Тб")
                Text("Емкость под данные \(String(format: "%.1f", raidItem.effectiveCapacity)) Тб").font(.footnote)
                Text("Диски под данные  \(raidItem.driveForData) шт").font(.footnote)
                
                Form {
                    Picker(selection: $raidItem.driveType, label: Text("")) {
                        Text("HDD").tag("HDD")
                        Text("SSD").tag("SSD")
                    }.pickerStyle(.segmented)
                        .background(raidItem.raidEngineIsOptimal ? Color.platformBackground : Color.red)
                                   .cornerRadius(8) // Закругленные углы для более приятного вида
                                   .animation(.easeInOut, value: !raidItem.raidEngineIsOptimal) // Анимация изменения цвета
                    
                    
                    // Отображаем и меняем количество дисков в рейде
                    Text("Дисков в RAID:  \(raidItem.driveCount) шт.").font(.footnote)
                    Slider(
                        value: Binding(
                            get: { Double(raidItem.driveCount) },
                            set: { raidItem.driveCount = Int($0) }
                        ),
                        in: minValue...maxValue,
                        step: raidItem.raidLevel.evenNumber ? 2 : 1 // Если рейд зеркальный то только четный выбор
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
                Spacer()
            

            }
            .onAppear {
                        // Устанавливаем размер окна для macOS
                        #if os(macOS)
                        if let window = NSApplication.shared.windows.first {
                            window.setContentSize(NSSize(width: 600, height: 800)) // Установить размер окна
                            window.center() // Центрируем окно на экране
                        }
                        #endif
                    }
            .padding(.horizontal)
            
            .navigationTitle("Добавить/изменить RAID")
            //.navigationTitle(raidItem == nil ? "Добавить RAID" : "Изменить RAID")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                       // presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        newConf.saveRaidItem(raidItem)
                        dismiss()
                        //presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .padding(.horizontal)
       
    }
    private func updateSelectedRaidLevel(for name: String) {
        raidItem.raidLevel =  newConf.raidLevels.first { $0.name == name } ?? RaidLevel()
        raidItem.driveType = raidItem.raidLevel.raidEngine ? "SSD" : "HDD"
        
    }
}

//#Preview {b
//    EditRaidView()
//}
