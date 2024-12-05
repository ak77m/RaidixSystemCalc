//
//  MyPickerView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 02.12.2024.
//


import SwiftUI

struct MyPickerView: View {
    let title: String
    @Binding var selection: String
    let options: [String]

    var body: some View {
        HStack (alignment: .center) {
            Text(title)
            Spacer()
            Picker(selection: $selection, label: Text("")) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
#if os(iOS)
                .pickerStyle(MenuPickerStyle())
#else
                .pickerStyle(DefaultPickerStyle())
#endif
        }
    }
}


