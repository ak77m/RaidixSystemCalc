//
//  FinalInfoView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 15.12.2024.
//

import SwiftUI

struct SystemInfoView: View {
    @EnvironmentObject var newConf: CalcManager
    
    var body: some View {
        VStack(alignment: .leading) {
            // Существующий контент
            
            Picker(selection: $newConf.system.systemType, label: Text("")) {
                Text("Один контроллер").tag(false)
                Text("Два контроллера").tag(true)
            }
            .pickerStyle(.segmented)
            
            SynchroView()
            SanView()
            NasView()
            CacheView()
            
            MyPickerView(title: newConf.system.description(for: "hbaAdapter"),
                         selection: $newConf.system.hbaAdapter,
                         arrayForSelect: newConf.sas)
                .font(.headline)
            
            Spacer()
            
            NavigationLink(destination: FinalInfoView()) {
                Text("Перейти к итогам")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    FinalInfoView()
}
