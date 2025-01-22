//
//  RaidView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 02.12.2024.
//

import SwiftUI

struct RaidView: View {
    @EnvironmentObject var newConf: CalcManager
    
    @State private var isPresentingEditView = false
    @State private var selectedRaidItem: RaidItem? = nil
    
    var body: some View {
        NavigationView {
            VStack{
                RaidTotalInfoView()
                
                List {
                    ForEach(newConf.system.raidsInSystem) { raid in
                        HStack{
                            RaidItemListView(item: raid).contentShape(Rectangle())
                            Button(action: {
                                newConf.saveDoubleItem(raid)
                            }) {
                                Image(systemName: "doc.on.doc") // Пиктограмма дублирования
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 24, height: 24) // Устанавливаем размер пиктограммы
                                    .foregroundColor(.blue)
                                    .padding(8) // Добавляем отступы для области нажатия
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                            .onTapGesture {
                                selectedRaidItem = raid
                                isPresentingEditView = true
                            }
                    }
                    .onDelete { indices in
                        newConf.system.raidsInSystem.remove(atOffsets: indices)
                    }
                }
                .navigationTitle("RAIDы системы")
                .toolbar {
                    ToolbarItem(placement: .principal ) { //.primaryAction
                        HStack {
                            Button(action: {
                                newConf.system = StorageSystem()
                            }) {
                                Text("Очистить")
                            }
                            
                            Spacer() // Отделяет кнопки друг от друга
                            
                            Button(action: {
                                selectedRaidItem = nil
                                isPresentingEditView = true
                            }) {
                                Text("+ RAID")
                                // Label("Добавить", systemImage: "plus")
                            }
                        }
                    }
                    
                }
                .sheet(isPresented: $isPresentingEditView) {
                    EditRaidView(raidItem: Binding(
                        get: { selectedRaidItem ?? RaidItem() },  // Передаем не `nil`, а новый объект по умолчанию
                        set: { newValue in
                            selectedRaidItem = newValue
                        }
                    ))
                    
                    // , raidSystems: $newConf.system.raidsInSystem
                }
                
                NavigationLink(destination: SystemInfoView()) {
                    Text("Перейти дальше")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(newConf.system.raidsInSystem.isEmpty ? Color.gray : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .disabled(newConf.system.raidsInSystem.isEmpty)
                .padding()
            }
            
            
            
        }
    }
}

#Preview {
    RaidView()
}
