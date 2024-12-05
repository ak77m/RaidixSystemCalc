//
//  RaidLevel.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 29.11.2024.
//

import Foundation

// Уровень рейда и лимиты
struct RaidLevel: Identifiable {
    var id: UUID = UUID()
    var name : String
    var raidEngine : Int // 0 - Generic, 1 - ERA
    var countDrivesRedundancy : Int  // Кол-во дисков отводящихся под избыточность
    var minDrives : Int
    var maxDrives : Int = 64
    var evenNumber : Bool // требуется четное количество
    
    var systemNameString : String {
        switch raidEngine {
        case 0:
            return "Generic"
        case 1:
            return "Era"
        default:
            return "Generic"
        }
    }
    
    
    init(name: String = "n/a", raidEngine: Int = 0, countDrivesRedundancy: Int = 0, minDrives: Int = 0, maxDrives: Int = 64,  evenNumber: Bool = false) {
        self.name = name
        self.raidEngine = raidEngine
        self.countDrivesRedundancy = countDrivesRedundancy
        self.minDrives = minDrives
        self.maxDrives = maxDrives
        self.evenNumber = evenNumber
    }
    
}

