//
//  RaidView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 02.12.2024.
//

import SwiftUI

struct RaidView: View {
        @EnvironmentObject var newConf: CalcManager
    
      //  @State private var raidsInSystem: [RaidItem] = []
        @State private var isPresentingEditView = false
        @State private var selectedRaidSystem: RaidItem? = nil

        var body: some View {
            NavigationView {
                VStack{
                    Section() {
                        HStack(alignment: .top){
                            VStack(alignment: .leading){
                                Text("Общая емкость системы: ")
                                Text("Эффективная емкость системы:")
                                Text("Всего дисков: \(newConf.system.totalDriveCount) шт")
                                Text("их них SSD:")
                                Text("их них HDD:")
                            }
                            Spacer()
                        }
                    }.padding(.horizontal)
                    
                    List {
                        ForEach(newConf.system.raidsInSystem) { raid in
                            HStack {
                                Text(raid.raidLevel.name)
                                Spacer()
                                Text("\(raid.driveCount) x ")
                                Text("\(raid.capacity) ТБ")
                            }
                            .onTapGesture {
                                selectedRaidSystem = raid
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
                                selectedRaidSystem = nil
                                isPresentingEditView = true
                            }) {
                                Label("Добавить", systemImage: "plus")
                            }
                        }
                    }
                    .sheet(isPresented: $isPresentingEditView) {
                        EditRaidView(raidItem: $selectedRaidSystem, raidSystems: $newConf.system.raidsInSystem)
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
                }//.frame(minWidth: 500, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                
                
            }
        }
}

#Preview {
    RaidView()
}
