//
//  PricesParser.swift
//  DollarTrack
//
//  Created by Елена Поспелова on 30.05.2021.
//

import Foundation

final class PricesParser: NSObject {
    private var prices: [Price] = []

    private var tempDate: Date?
    private var tempNumber: Float?
    private var elementName = ""

    func parse(data: Data) -> [Price] {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return prices
    }
}

extension PricesParser: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "Record", let dateString = attributeDict["Date"] {
            tempDate = Enviroment.responceDateFormatter.date(from: dateString)
        }
        self.elementName = elementName
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if (!data.isEmpty) {
            if elementName == "Value" {
                let number = data.replacingOccurrences(of: ",", with: ".")
                tempNumber = Float(number)
            }
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        guard elementName == "Record",
           let date = tempDate,
           let number = tempNumber
        else { return }
        let price = Price(date: date, number: number)
        prices.append(price)
        tempDate = nil
        tempNumber = nil
    }
}
