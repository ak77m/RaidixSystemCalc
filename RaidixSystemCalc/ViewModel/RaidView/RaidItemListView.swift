//
//  RaidItemListView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 09.12.2024.
//

import SwiftUI

struct RaidItemListView: View {
    var item: RaidItem
    var body: some View {
        HStack {
            VStack(alignment: .leading){
                Text("\(item.driveType) ").font(.footnote)
                Text(item.raidLevel.systemNameString).font(.footnote)
            }
            .foregroundColor(item.raidEngineIsOptimal ? .primary : .red ) // красим красным если рейд не оптимальный
            
            Text(item.raidLevel.name).padding(.horizontal)
            
            Spacer()
            Text("\(item.driveCount) x ")
            Text("\(String(format: "%.1f", item.capacity)) ТБ")
        }
        
    }
}

#Preview {
    let item = RaidItem(id: UUID(), driveCount: 20, capacity: 20.0, driveType: "SSD", raidLevel: RaidLevel())
    RaidItemListView(item: item)
}
