//
//  CalcManager.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 29.11.2024.
//

import Foundation

final class CalcManager: ObservableObject {
    
    @Published var system = StorageSystem()
    
    @Published var sas: [String] = []
    @Published var fc: [String] = []
    @Published var iscsi: [String] = []
    @Published var srp: [String] = []
    @Published var iser: [String] = []
    
    @Published var raidLevels: [RaidLevel] = []
    
    init() {
        parseAdaptersFile()
        raidLevels = parseRaidLevels(from: "RaidList")
    }
    
    func parseAdaptersFile() {
            guard let filePath = Bundle.main.path(forResource: "Adapters", ofType: "txt") else {
                print("Файл не найден")
                return
            }

            do {
                let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
                let lines = fileContents.split(separator: "\n")

                for line in lines {
                    let components = line.split(separator: ":", omittingEmptySubsequences: false)
                        .map { $0.trimmingCharacters(in: .whitespaces) }
                    guard components.count >= 2 else { continue }

                    let name = components[0].replacingOccurrences(of: " ", with: "")
                    if components.count > 1 && components[1] == "1" {
                        sas.append(name)
                    }
                    if components.count > 2 && components[2] == "1" {
                        fc.append(name)
                    }
                    if components.count > 3 && components[3] == "1" {
                        iscsi.append(name)
                    }
                    if components.count > 4 && components[4] == "1" {
                        srp.append(name)
                    }
                    if components.count > 5 && components[5] == "1" {
                        iser.append(name)
                    }
                }
            } catch {
                print("Ошибка чтения файла: \(error)")
            }
        }
    
    func saveRaidItem(_ raidItem: RaidItem) {
        // raidSystems: $newConf.system.raidsInSystem)
        
        if let index = system.raidsInSystem.firstIndex(where: { $0.id == raidItem.id }) {
            system.raidsInSystem[index] = raidItem
        } else {
            system.raidsInSystem.append(raidItem)
        }
    }
    
    func parseRaidLevels(from fileName: String) -> [RaidLevel] {
        var raidLevels: [RaidLevel] = []

        // Чтение содержимого файла
        guard let filePath = Bundle.main.path(forResource: fileName, ofType: "txt"),
              let fileContents = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            print("Не удалось загрузить файл \(fileName)")
            return []
        }

        // Обработка строк файла
        let lines = fileContents.split(separator: "\n")
        for line in lines {
            // Разделяем строку на компоненты и удаляем пробелы
            let components = line
                .split(separator: ":")
                .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }

            if components.count == 6,
               let raidEngine = Bool(components[1]),
               let countDrivesRedundancy = Int(components[2]),
               let minDrives = Int(components[3]),
               let maxDrives = Int(components[4]),
               let evenNumber = Bool(components[5]) {
                let raidLevel = RaidLevel(
                    name: components[0],
                    raidEngine: raidEngine,
                    countDrivesRedundancy: countDrivesRedundancy,
                    minDrives: minDrives,
                    maxDrives: maxDrives,
                    evenNumber: evenNumber
                )
                raidLevels.append(raidLevel)
            } else {
                print("Ошибка в строке: \(line)")
            }
        }

        return raidLevels
    }
    
    func minMaxValueCorrection(_ newValue: RaidLevel?, count: Int) -> Int{
        guard let newValue else { return count}
        let min = Double(newValue.minDrives)
        let max = Double(newValue.maxDrives)
        if Double(count) < min {
            return Int(min)
        } else if Double(count) > max {
            return Int(max)
        }
        return count
    }
    
    
    
}
