//
//  Float+String.swift
//  DollarTrack
//
//  Created by Елена Поспелова on 31.05.2021.
//

import Foundation

extension Float {
    var stringDisplay: String {
        return String(format: "%.2f", self)
    }
}
