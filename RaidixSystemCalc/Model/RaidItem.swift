//
//  RaidItem.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 29.11.2024.
//

import Foundation


/// Структура для описания каждого рейда системы

struct RaidItem: Identifiable {
    var id: UUID = UUID()
    var driveCount: Int = 0 // Количество дисков в группе
    var capacity: Double = 0.0 // Емкость 1 диска
    var driveType: String = "HDD" // "HDD", "SSD"
    var raidLevel: RaidLevel = RaidLevel()
    
    
    // Вычисляемые переменные
    
    // Количество дисков под данные = Кол-во дисков минус избыточность | но <0 быть не может
    var driveForData: Int {
        max(0, driveCount - raidLevel.countDrivesRedundancy)
    }
    // Общая емкость = кол-во дисков * емкость
    var totalCapacity: Double {
        Double(driveCount) * capacity
    }
    
    // Эффективная емкость = диски под данные * емкость | но <0 быть не может
    var effectiveCapacity: Double {
        max(0, Double((driveCount - raidLevel.countDrivesRedundancy)) * capacity)
    }
    
    // Проверяем используется ли оптимальное сочетание движка и типа диска
    var raidEngineIsOptimal: Bool {
        (driveType == "HDD" && !raidLevel.raidEngine) ||
        (driveType == "SSD" && raidLevel.raidEngine)
    }
    
    // Для RAID с Era Engine = 1, Generic = 0
    var RaidWithEra: Int {
        raidLevel.raidEngine ? 1 : 0
    }
    
    
    
    static func descriptions() -> [String: String] {
        return [
            "id": "Тип RAID",
            "driveCount": "Количество дисков в группе",
            "capacity": "Емкость диска в ТБ",
            "driveType": "Тип диска"
        ]
    }
}
