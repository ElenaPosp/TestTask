//
//  ViewController.swift
//  DollarTrack
//
//  Created by Елена Поспелова on 30.05.2021.
//

import UIKit

class ViewController: UIViewController {

    private var prices: [Price] = []
    private lazy var infoService: InfoServiceProtocol = InfoService()
    
    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter
    }()

    @IBOutlet weak var priceTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTable()
        loadPrices()
        checkCurrentPrice()
    }

    private func loadPrices() {
        infoService.getPrices { [weak self] result in
            switch result {
            case .success(let prices):
                self?.prices = prices

                DispatchQueue.main.async { [weak self] in
                    self?.priceTableView.reloadData()
                    self?.checkCurrentPrice()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func setupTable() {
        priceTableView.delegate = self
        priceTableView.dataSource = self
        priceTableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.description())
    }
    
    private func checkCurrentPrice() {
        let defaults = UserDefaults.standard
        let calendar = Calendar.current
        if let lastCheckDate = defaults.value(forKey: Enviroment.lastCheckDateKey) as? Date,
           calendar.isDateInToday(lastCheckDate) {
            return
        }
        let todayPrice = prices.first(where: { calendar.isDateInToday($0.date) })
        guard let todayPrice = todayPrice, todayPrice.number > Enviroment.thresholdPrice else { return }
        let difference = todayPrice.number - Enviroment.thresholdPrice
        let controller = UIAlertController(
            title: "Attension!",
            message: "The price today is \(difference.stringDisplay)$ more",
            preferredStyle: .alert
        )
        controller.addAction(.init(title: "Okay", style: .cancel, handler: nil))
        present(controller, animated: true) {
            UserDefaults.standard.set(Date(), forKey: Enviroment.lastCheckDateKey)
        }
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = priceTableView.dequeueReusableCell(withIdentifier: UITableViewCell.description(),
                                                      for: indexPath)
        let price = prices[indexPath.row]
        let niceDate = formatter.string(from: price.date)
        let niceNumber = price.number.stringDisplay
        cell.textLabel?.text = "Date: \(niceDate). Price: \(niceNumber)$"
        return cell
    }
}
