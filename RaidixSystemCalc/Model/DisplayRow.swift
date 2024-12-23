//
//  DisplayRow.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 17.12.2024.
//

import Foundation

struct DisplayRow: Identifiable {
    var id = UUID()
    var isHeader: Bool
    var condition: (StorageSystem) -> Bool
    var description: String
    var value: (StorageSystem) -> String  
}
