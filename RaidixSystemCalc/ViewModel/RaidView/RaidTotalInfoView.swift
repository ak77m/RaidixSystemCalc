//
//  RaidTotalInfoView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 09.12.2024.
//

import SwiftUI

struct RaidTotalInfoView: View {
    
    @EnvironmentObject var newConf: CalcManager
    
    var body: some View {
        Section() {
            HStack(alignment: .top){
                VStack(alignment: .leading){
                    WideTextView(disription: "Общая емкость, ТБ:",
                                 value: String(format: "%.1f", newConf.system.totalCapacity))
                    WideTextView(disription: "Эффективная емкость, ТБ: ",
                                 value: String(format: "%.1f", newConf.system.effectiveCapacity))
                    
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Всего дисков: \(newConf.system.totalDriveCount) шт").font(.footnote)
                            .foregroundColor(newConf.system.DriveCountOutOfRange ? .red : .primary ) 
                        Text("их них SSD: \(newConf.system.ssdDrives)").font(.footnote)
                        Text("их них HDD: \(newConf.system.hddDrives)").font(.footnote)
                    }.padding(.leading)
                    
                }
                Spacer()
            }
        }.padding(.horizontal)
    }
}

#Preview {
    RaidTotalInfoView().environmentObject(CalcManager())
}
