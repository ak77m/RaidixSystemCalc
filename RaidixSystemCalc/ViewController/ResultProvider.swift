//
//  ResultProvider.swift
//  RaidixSystemCalc
//
//  Created by aleksey.kazakov on 18.12.2024.
//

//import Foundation
import UIKit
import SwiftUI

final class ResultProvider {
    
    func exportToCSV(system: StorageSystem, fileName: String) {
            // Получаем данные для экспорта из обеих секций
            let resultRows = finalResult(system)
            let raidRows = system.raidsInSystem.map { raid in
                "RAID: \(raid.raidLevel.systemNameString), Количество дисков: \(raid.driveCount)"
            }
            
            // Собираем данные в строку CSV
            var csvString = "Описание,Значение\n" // Заголовки столбцов
            for row in resultRows {
                if row.condition(system) {
                    let value = row.value(system).isEmpty ? "Нет данных" : row.value(system)
                    csvString.append("\"\(row.description)\",\"\(value)\"\n")
                }
            }
            for raidRow in raidRows {
                csvString.append("\"\(raidRow)\",\n")
            }
            
            // Сохранение и вызов диалога "Поделиться"
            shareCSVFile(csvString: csvString, fileName: fileName)
        }
        
        private func shareCSVFile(csvString: String, fileName: String) {
            // Создаем временный файл
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileURL = tempDirectory.appendingPathComponent("\(fileName).csv")
            
            do {
                // Записываем CSV в файл
                try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
                
                // Вызов диалога "Поделиться"
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
            } catch {
                print("Ошибка при создании CSV-файла: \(error)")
            }
        }
       // Функция для сохранения строки в файл
//       private func saveToFile(_ data: String, fileName: String) {
//           // Получаем путь для сохранения
//           if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//               let fileURL = documentDirectory.appendingPathComponent("\(fileName).csv")
//               
//               do {
//                   // Записываем данные в файл
//                   try data.write(to: fileURL, atomically: true, encoding: .utf8)
//                   print("Файл сохранен по пути: \(fileURL.path)")
//               } catch {
//                   print("Ошибка при сохранении файла: \(error)")
//               }
//           }
//       }
    
    func finalResult(_ result: StorageSystem) -> [DisplayRow] {
        return [
            // Рекомендации к аппаратной платформе
            DisplayRow(isHeader: true, condition: { _ in true }, description: "Рекомендации к аппаратной платформе", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in result.platform }, description: "Контроллер с 2CPU", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in !result.platform }, description: "Контроллер с 1CPU", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "Процессор", value: { _ in result.cpuModel }), // теперь передаем замыкание, которое возвращает строку
            DisplayRow(isHeader: false, condition: { _ in true }, description: "Оперативная память", value: { _ in String(result.ram) }),
            
            // Общая информация о СХД
            DisplayRow(isHeader: true, condition: { _ in true }, description: "Общая информация о СХД", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "Общая емкость системы хранения, ТБ", value: { _ in String(format: "%.1f",result.totalCapacity) }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "Эффективная емкость, ТБ", value: { _ in String(format: "%.1f",result.effectiveCapacity) }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "Количество дисков в системе", value: { _ in String(result.totalDriveCount + result.ssdCache * 2) }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "- из них HDD", value: { _ in String(result.hddDrives) }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "- из них SSD", value: { _ in String(result.ssdDrives) }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "- из них SSD для кэш", value: { _ in String(result.ssdCache * 2) }),
            
            // Функциональность
            DisplayRow(isHeader: true, condition: { _ in true }, description: "Функциональность", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in  !result.systemType }, description: "Одноконтроллерная система", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in result.systemType }, description: "Двухконтроллерная система", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in result.systemType }, description: "Протокол синхронизации", value: { _ in result.synchronization }),
            DisplayRow(isHeader: false, condition: {_ in  result.systemType }, description: "Адаптер интерконнекта", value: { _ in result.synchroAdapter }),
            DisplayRow(isHeader: false, condition: {_ in  result.systemType }, description: "Адаптер хартбита", value: { _ in "необходимо предусмотреть" }),
            
            // SAN функциональность
            DisplayRow(isHeader: true, condition: { _ in result.sanFunctionality }, description: "Блочный доступ", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in result.sanFunctionality && result.iscsiProtocol }, description: "Поддержка iSCSI", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in result.sanFunctionality && result.iscsiProtocol }, description: "Адаптер iSCSI", value: { _ in result.iscsiAdapter }),
            DisplayRow(isHeader: false, condition: { _ in  result.sanFunctionality && result.iserProtocol }, description: "Поддержка iSER", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in result.sanFunctionality && result.iserProtocol }, description: "Адаптер iSER", value: { _ in result.iserAdapter }),
            DisplayRow(isHeader: false, condition: { _ in result.sanFunctionality && result.fcProtocol }, description: "Поддержка FCP", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in result.sanFunctionality && result.fcProtocol }, description: "Адаптер FCP", value: { _ in result.fcAdapter }),
            DisplayRow(isHeader: false, condition: { _ in result.sanFunctionality && result.srpProtocol }, description: "Поддержка SRP", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in  result.sanFunctionality && result.srpProtocol }, description: "Адаптер SRP", value: { _ in result.srpAdapter }),
            
            // NAS функциональность
            DisplayRow(isHeader: true, condition: { _ in result.nasFunctionality }, description: "Файловый доступ", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in result.nasFunctionality }, description: "Адаптер eth", value: { _ in result.ethAdapter }),
            
            // SSD кэш
            DisplayRow(isHeader: true, condition: { _ in result.ssdCache > 0 }, description: "SSD кэш", value: { _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in result.ssdCache > 0 }, description: "Кол-во SSD дисков", value: { _ in  String(result.ssdCache * 2) }),
            
            // HBA адаптер
            DisplayRow(isHeader: true, condition: { _ in true }, description: "Подключение дисков через:", value: {  _ in "" }),
            DisplayRow(isHeader: false, condition: { _ in true }, description: "HBA адаптер", value: { _ in result.hbaAdapter })
        ]
    }
    
    
}
