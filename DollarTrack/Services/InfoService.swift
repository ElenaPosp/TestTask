//
//  InfoService.swift
//  DollarTrack
//
//  Created by Елена Поспелова on 30.05.2021.
//

import Foundation

protocol InfoServiceProtocol {
    func getPrices(completion: @escaping (Result<[Price], Error>) -> Void)
}

final class InfoService: NSObject, InfoServiceProtocol {

    func getPrices(completion: @escaping (Result<[Price], Error>) -> Void) {
        guard let url = getUrl() else {
            completion(.failure(NSError()))
            return
        }
        let defaultSession = URLSession(configuration: .default)
        defaultSession.dataTask(with: .init(url: url), completionHandler: { data, response, error in
            if let responceError = error {
                completion(.failure(responceError))
                return
            }
            guard
                let response = response as? HTTPURLResponse,
                response.statusCode == 200,
                let strongData = data
            else {
                completion(.failure(NSError()))
                return
            }
            let prices = PricesParser().parse(data: strongData)
            completion(.success(prices))
        }).resume()
    }
    
    private func getUrl() -> URL? {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let toDate = Date()
        let fromDate = Date(timeInterval: -2600000, since: toDate)
        let toDateString = formatter.string(from: toDate)
        let fromDateString = formatter.string(from: fromDate)
        return Enviroment.getUrl(from: fromDateString, to: toDateString)
    }
}
