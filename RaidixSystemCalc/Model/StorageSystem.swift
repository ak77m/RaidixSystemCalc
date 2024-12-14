//
//  StorageSystem.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 29.11.2024.
//

import Foundation


/// Основная структура с базовыми переменными
struct StorageSystem {
    // Основные параметры

    var systemType: Bool = false
    var sanFunctionality: Bool = false
    var nasFunctionality: Bool = false
    var synchronization: String = "iscsi"
    var iscsiProtocol: Bool = false
    var iserProtocol: Bool = false
    var fcProtocol: Bool = false
    var srpProtocol: Bool = false
    var ssdCache: Int = 1
    var raidsInSystem: [RaidItem] = []
    var hbaAdapter: String = "Пусто"
    var synchroAdapter: String = "Пусто"
    var iscsiAdapter: String = "Пусто"
    var iserAdapter: String = "Пусто"
    var fcAdapter: String = "Пусто"
    var srpAdapter: String = "Пусто"
    var ethAdapter: String = "Пусто"
    var cpuModel: String = "Default CPU Model"
    var cpuCores: String = "4 cores"
    var cpuFrequency: String = "2.0 GHz"
    var ram: String = "8 GB"
    
// Вычисляемые переменные
    
    // Всего дисков в системе
    var totalDriveCount: Int {
        raidsInSystem.reduce(0) { $0 + $1.driveCount }
    }
    
    // Общая емкость
    var totalCapacity: Double {
        raidsInSystem.reduce(0) { $0 + $1.totalCapacity }
    }
    
    // Эффективная емкость Тб
    var effectiveCapacity: Double {
        raidsInSystem.reduce(0) { $0 + $1.effectiveCapacity }
    }
    
    // Всего SSD дисков  
    var ssdDrives: Int {
        raidsInSystem.reduce(0) { $0 + ($1.driveType == "SSD" ? $1.driveCount : 0) }
    }
    var hddDrives: Int {
        raidsInSystem.reduce(0) { $0 + ($1.driveType == "HDD" ? $1.driveCount : 0) }
    }
    
    var DriveCountOutOfRange: Bool { // проверяем выход за пределы лимита дисков. 132 нужно вынести в справочник переменных
        return totalDriveCount > 132
    }
    

// Текстовые дескрипторы
    func description(for key: String) -> String {
            let descriptions = [
                "systemType": "Тип системы: SC или DC",
                "synchronization": "Протокол синхронизации",
                "synchroAdapter": "Адаптер для синхронизации",
                "nasFunctionality": "Файловый доступ",
                "sanFunctionality": "Блочный доступ",
                "iscsiProtocol": "Поддержка iSCSI",
                "iserProtocol": "Поддержка iSER",
                "fcProtocol": "Поддержка FiberChanel",
                "srpProtocol": "Поддержка InfiniBand",
                "ssdCache": "SSD-кэш на контролерах",
                "raid": "Рейд-группы системы",
                "hbaAdapter": "HBA адаптер",
                "iscsiAdapter": "iSCSI адаптер",
                "iserAdapter": "iSER адаптер",
                "fcAdapter": "FC адаптер",
                "srpAdapter": "IB адаптер",
                "ethAdapter": "NAS адаптер",
                
                "cpuModel": "Модель процессора",
                "cpuCores": "Количество ядер процессора",
                "cpuFrequency": "Частота процессора",
                "ram": "Оперативная память системы"
            ]
            return descriptions[key] ?? "Unknown"
        }
    
    
}



