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
    var systemType: Bool // Тип системы, SC - false или DC - true
    var sanFunctionality: Bool // Блочный доступ (true, false)
    var nasFunctionality: Bool // Файловый доступ (true, false)
    
    var synchronization: String // Протокол используемый для синхронизации (iscsi, iser, srp)
    var synchroAdapter: String // Адаптер для синхронизации (берется из справочника [String])
    
    var iscsiProtocol: Bool // Использование iSCSI (true, false)
    var iserProtocol: Bool // Использование iSER (true, false)
    var fcProtocol: Bool // Использование FiberChanel (true, false)
    var srpProtocol: Bool // Использование InfinBand (true, false)
    
    var ssdCache: Int // Размер кэша SSD (1, 2)
    var raidsInSystem: [RaidItem] // Рейд-группы системы
    
    var hbaAdapter: String // HBA адаптер (берется из справочника [String])
    
    var fcAdapter: String // FC-адаптер (берется из справочника [String])
    var ethAdapter: String // Eth адаптер (берется из справочника [String])
    var iscsiAdapter: String // iSCSI адаптер (берется из справочника [String])
    var srpAdapter: String // IB адаптер (берется из справочника [String])
    
    // TODO
    var cpuModel: String // Модель CPU (берется из справочника [String])
    var cpuCores: String // Количество ядер CPU (берется из справочника [String])
    var cpuFrequency: String // Частота CPU (берется из справочника [String])
    var ram: String // Оперативная память (вычисляется исходя из кол-ва дисков и рейд-групп)

    
    //
    // Вычисляемая переменная - Всего дисков в системе
        var totalDriveCount: Int {
            raidsInSystem.reduce(0) { $0 + $1.driveCount }
        }
    
    
    init(
            systemType: Bool = false,
            sanFunctionality: Bool = false,
            nasFunctionality: Bool = false,
            synchronization: String = "iscsi",
            iscsiProtocol: Bool = false,
            iserProtocol: Bool = false,
            fcProtocol: Bool = false,
            srpProtocol: Bool = false,
            ssdCache: Int = 1,
            raidsInSystem: [RaidItem] = [],
            hbaAdapter: String = "",
            synchroAdapter: String = "",
            fcAdapter: String = "",
            ethAdapter: String = "",
            iscsiAdapter: String = "",
            srpAdapter: String = "",
            cpuModel: String = "Default CPU Model",
            cpuCores: String = "4 cores",
            cpuFrequency: String = "2.0 GHz",
            ram: String = "8 GB"
        ) {
            self.systemType = systemType
            self.sanFunctionality = sanFunctionality
            self.nasFunctionality = nasFunctionality
            self.synchronization = synchronization
            self.iscsiProtocol = iscsiProtocol
            self.iserProtocol = iserProtocol
            self.fcProtocol = fcProtocol
            self.srpProtocol = srpProtocol
            self.ssdCache = ssdCache
            self.raidsInSystem = raidsInSystem
            self.hbaAdapter = hbaAdapter
            self.synchroAdapter = synchroAdapter
            self.fcAdapter = fcAdapter
            self.ethAdapter = ethAdapter
            self.iscsiAdapter = iscsiAdapter
            self.srpAdapter = srpAdapter
            self.cpuModel = cpuModel
            self.cpuCores = cpuCores
            self.cpuFrequency = cpuFrequency
            self.ram = ram
        }

    func description(for key: String) -> String {
            let descriptions = [
                "systemType": "Тип системы: SC или DC",
                
                "synchronization": "Протокол синхронизации",
              
                "synchroAdapter": "Адаптер для синхронизации",
                
                
                "nasFunctionality": "Файловый доступ",
                
               //
                "sanFunctionality": "Блочный доступ",
                
                "iscsiProtocol": "Поддержка iSCSI",
                "iserProtocol": "Поддержка iSCSI",
                "fcProtocol": "Поддержка FiberChanel",
                "srpProtocol": "Поддержка InfiniBand",
                
                
                "ssdCache": "SSD-кэш на контролерах",
                "raid": "Рейд-группы системы",
                "hbaAdapter": "HBA адаптер",
                
                "fcAdapter": "FC адаптер",
                "ethAdapter": "NAS адаптер",
                "iscsiAdapter": "iSCSI адаптер",
                "srpAdapter": "IB адаптер",
                
                "cpuModel": "Модель процессора",
                "cpuCores": "Количество ядер процессора",
                "cpuFrequency": "Частота процессора",
                "ram": "Оперативная память, вычисляется исходя из количества дисков и рейд-групп"
            ]
            return descriptions[key] ?? "Unknown"
        }
    
    
}



