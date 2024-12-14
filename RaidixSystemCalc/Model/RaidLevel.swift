//
//  RaidLevel.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 29.11.2024.
//

import Foundation

// Уровень рейда и лимиты
struct RaidLevel: Identifiable, Equatable {
    var id: UUID = UUID()
    var name : String = "Пусто"         // Название рейда
    var raidEngine : Bool = false       // false - Generic, true - ERA
    var countDrivesRedundancy : Int = 0 // Кол-во дисков отводящихся под избыточность
    var minDrives : Int = 0             // Минимальное кол-во дисков в рейде
    var maxDrives : Int = 1             // Максимальное кол-во дисков в рейде
    var evenNumber : Bool = false       // требуется четное количество
    
    var systemNameString : String {
        switch raidEngine {
        case false:
            return "Generic"
        case true:
            return "Era"
        
        }
    }
 
}

