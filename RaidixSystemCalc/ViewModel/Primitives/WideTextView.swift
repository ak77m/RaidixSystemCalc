//
//  WideTextView.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 09.12.2024.
//

import SwiftUI

struct WideTextView: View {
    let disription: String
    let value: String
    var body: some View {
        HStack {
            Text(disription)
            Spacer()
            Text(value).fontWeight(.bold)
            
        }
    }
}

#Preview {
    WideTextView(disription: "Описание", value: "Значение")
}
