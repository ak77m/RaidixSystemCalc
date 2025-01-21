//
//  ResultProvider.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 18.12.2024.
//

import SwiftUI

final class ResultProvider {
    func exportToCSV(system: StorageSystem, fileName: String) {
        let resultRows = finalResult(system)
        let raidRows = system.raidsInSystem.map { raid in
            "RAID: \(raid.raidLevel.systemNameString), Количество дисков: \(raid.driveCount)"
        }
        
        var csvString = "Описание,Значение\n"
        for row in resultRows {
            if row.condition(system) {
                let value = row.value(system).isEmpty ? "Нет данных" : row.value(system)
                csvString.append("\"\(row.description)\",\"\(value)\"\n")
            }
        }
        for raidRow in raidRows {
            csvString.append("\"\(raidRow)\",\n")
        }
        
        saveAndShareCSV(csvString: csvString, fileName: fileName)
    }
    
    private func saveAndShareCSV(csvString: String, fileName: String) {
        let tempDirectory = FileManager.default.temporaryDirectory
        let fileURL = tempDirectory.appendingPathComponent("\(fileName).csv")
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            #if os(iOS)
            shareOnIOS(fileURL: fileURL)
            #elseif os(macOS)
            shareOnMacOS(fileURL: fileURL)
            #endif
        } catch {
            print("Ошибка при создании CSV-файла: \(error)")
        }
    }
    
    #if os(iOS)
    private func shareOnIOS(fileURL: URL) {
        DispatchQueue.main.async {
            let activityViewController = UIActivityViewController(
                activityItems: [fileURL],
                applicationActivities: nil
            )
            if let rootController = UIApplication.shared.connectedScenes
                .flatMap({ ($0 as? UIWindowScene)?.windows ?? [] })
                .first(where: { $0.isKeyWindow })?.rootViewController {
                rootController.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    #endif
    
    #if os(macOS)
    private func shareOnMacOS(fileURL: URL) {
        let panel = NSSavePanel()
        panel.directoryURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first
        panel.nameFieldStringValue = fileURL.lastPathComponent
        panel.begin { result in
            if result == .OK, let destinationURL = panel.url {
                do {
                    try FileManager.default.copyItem(at: fileURL, to: destinationURL)
                    print("Файл успешно сохранён в: \(destinationURL.path)")
                } catch {
                    print("Ошибка копирования файла: \(error)")
                }
            }
        }
    }
    #endif
    
    func finalResult(_ result: StorageSystem) -> [DisplayRow] {
        return [
            DisplayRow(isHeader: true, condition: { _ in true }, description: "Рекомендации к аппаратной платформе", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in result.platform }, description: "Контроллер с 2CPU", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in !result.platform }, description: "Контроллер с 1CPU", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "Процессор", value: { _ in result.cpuModel }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "Оперативная память", value: { _ in String(result.ram) }),
            DisplayRow(isHeader: true, condition: { _ in true }, description: "Общая информация о СХД", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "Общая емкость системы хранения, ТБ", value: { _ in String(format: "%.1f",result.totalCapacity) }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "Эффективная емкость, ТБ", value: { _ in String(format: "%.1f",result.effectiveCapacity) }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "Количество дисков в системе", value: { _ in String(result.totalDriveCount + result.ssdCache * 2) }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "- из них HDD", value: { _ in String(result.hddDrives) }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "- из них SSD", value: { _ in String(result.ssdDrives) }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "- из них SSD для кэш", value: { _ in String(result.ssdCache * 2) }),
            DisplayRow(isHeader: true, condition: { _ in result.ssdCache > 0 }, description: "SSD кэш", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in result.ssdCache > 0 }, description: "Кол-во SSD дисков", value: { _ in  String(result.ssdCache * 2) })
        ]
    }
}
