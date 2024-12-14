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
                        RaidItemListView(item: raid)
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
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            selectedRaidItem = nil
                            isPresentingEditView = true
                        }) {
                            Label("Добавить", systemImage: "plus")
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
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
            
            
            
        }
    }
}

#Preview {
    RaidView()
}
