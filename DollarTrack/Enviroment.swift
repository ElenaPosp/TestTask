//
//  Enviroment.swift
//  DollarTrack
//
//  Created by Елена Поспелова on 30.05.2021.
//

import Foundation

enum Enviroment {
    static let thresholdPrice: Float = 35.00
    
    static let lastCheckDateKey = "LastCheckDateKey"

    static let responceDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()

    static func getUrl(from: String, to: String) -> URL? {
        return URL(string: "https://www.cbr.ru/scripts/XML_dynamic.asp?date_req1=\(from)&date_req2=\(to))&VAL_NM_RQ=R01235")
    }
}
