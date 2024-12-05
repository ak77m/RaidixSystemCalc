//
//  RaidixSystemCalcApp.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 29.11.2024.
//

import SwiftUI
import SwiftData

@main
struct RaidixSystemCalcApp: App {


    let config = CalcManager()
    
    var body: some Scene {
        WindowGroup {
            RaidView().environmentObject(config)
        }
        
    }
}
