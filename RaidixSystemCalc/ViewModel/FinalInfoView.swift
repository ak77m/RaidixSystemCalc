//
//  FinalInfoView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 15.12.2024.
//

import SwiftUI

import SwiftUI

struct FinalInfoView: View {
    @EnvironmentObject var newConf: CalcManager
    private let resultProvider = ResultProvider() // Провайдер данных
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                List {
                    Section(header: Text("Итоговая информация")) {
                        ForEach(resultProvider.finalResult(newConf.system), id: \.description) { row in
                            if row.condition(newConf.system) {
                                if row.isHeader {
                                    Text(row.description)
                                        .font(.headline)
                                        .padding(.vertical, 5)
                                } else {
                                    HStack {
                                        // Проверяем, если значение пустое, то текст будет занимать всю строку
                                        if row.value(newConf.system).isEmpty {
                                            Text(row.description)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        } else {
                                            Text(row.description)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(row.value(newConf.system)) // Вызываем замыкание для получения значения
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Section(header: Text("Список RAID")) {
                        ForEach(newConf.system.raidsInSystem) { raid in
                            RaidItemListView(item: raid)
                            
                        }
                    }
                }
            }
            
            //            Button(action: {
            //                resultProvider.exportToCSV(system: newConf.system, fileName: "FinalReport")
            //            }) {
            //                Text("Export to CSV")
            //                    .padding()
            //                    .background(Color.blue)
            //                    .foregroundColor(.white)
            //                    .cornerRadius(8)
            //            }
        }
        .navigationTitle("Финальный отчет")
            .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                resultProvider.exportToCSV(system: newConf.system, fileName: "FinalReport")
                            }) {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title2)
                            }
                        }
                    }
        
    }
}

#Preview {
    FinalInfoView().environmentObject(CalcManager())
}

