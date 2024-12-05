//
//  RaidItem.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 29.11.2024.
//

import Foundation


/// Структура для описания Рейд-групп системы

struct RaidItem: Identifiable {
    var id: UUID
    var driveCount: Int // Количество дисков в группе
    var capacity: Int // Емкость 1 диска
    var driveType: Int // 1 - HDD, 2 - SSD
    var raidLevel: RaidLevel
    
    // Вычисляемые переменные
    var driveForData: Int {
        max(0, driveCount - raidLevel.countDrivesRedundancy) // Количество дисков под данные = Кол-во дисков минус избыточность | но <0 быть не может
    }
    
    var totalCapacity: Int {
        max(0, driveCount * capacity) // Общая емкость = кол-во дисков * емкость | но <0 быть не может
    }
    
    var effectiveCapacity: Int {
        max(0, (driveCount - raidLevel.countDrivesRedundancy) * capacity) // Эффективная емкость = диски под данные * емкость | но <0 быть не может
    }
    
 
    init(
            id: UUID = UUID(),
            diskCount: Int = 0,
            capacity: Int = 0,
            driveType: Int = 0,
            raidLevel: RaidLevel = RaidLevel()
        ) {
            self.id = id
            self.driveCount = diskCount
            self.capacity = capacity
            self.driveType = driveType
            self.raidLevel = raidLevel
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
