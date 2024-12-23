//
//  CacheView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 14.12.2024.
//

import SwiftUI

struct CacheView: View {
    @EnvironmentObject var newConf: CalcManager
    
    var body: some View {
        if newConf.system.hddDrives > 0{
            HStack (alignment: .center) {
                Text(newConf.system.description(for: "ssdCache")).font(.headline)
                Spacer()
                Picker(selection: $newConf.system.ssdCache, label: Text("")) {
                    Text("Нет").tag(0)
                    Text("На 1 ноде").tag(1)
                    Text("На 2х нодах").tag(2)
                }.tint(.blue)
#if os(iOS)
                .pickerStyle(MenuPickerStyle())
#else
                .pickerStyle(DefaultPickerStyle())
#endif
            }
            
        }
    }
}

#Preview {
    CacheView()
}
