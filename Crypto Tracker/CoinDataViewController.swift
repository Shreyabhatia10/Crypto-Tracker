//
//  CoinDataViewController.swift
//  Crypto Tracker
//
//  Created by Shreya Bhatia on 16/05/22.
//

import UIKit
import SwiftChart

private let chartHeight: CGFloat = 300.0
private let imageSize: CGFloat = 100.0
private let lableHeight: CGFloat = 25.0
private let spacing: CGFloat = 32

class CoinDataViewController: UIViewController, CoinDataDelegate {
    
    var chart = Chart()
    var coin : Coin?
    var priceLabel = UILabel()
    var youOwnLabel = UILabel()
    var worthLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        CoinData.shared.delegate = self
//        edgesForExtendedLayout = []
        view.backgroundColor = .white
        title = coin?.symbol
        
        self.setupBarButtonItem()
        
        self.setUpSubviews()
        
        coin?.getHistoricalData()
        
        newPrices()
    }
    
    private func setupBarButtonItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }
    
    @objc func editTapped() {
        if let coin = coin {
            let alert = UIAlertController(title: "How much \(coin.symbol) do you own?", message: nil, preferredStyle: .alert)
            alert.addTextField { textField in
                textField.placeholder = "0.5"
                textField.keyboardType = .decimalPad
                if self.coin?.amount != 0.0 {
                    textField.text = String(coin.amount)
                }
                
            }
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                if let text = alert.textFields?[0].text {
                    if let amount = Double(text) {
                        self.coin?.amount = amount
                        self.newPrices()
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    private func setUpSubviews() {
        if let coin = coin {
            chart.frame = CGRect(x: 16, y: 150, width: view.frame.size.width - spacing, height: chartHeight)
            chart.yLabelsFormatter = { CoinData.shared.doubleToMoneyString(double: $1) }
            chart.xLabels = [30, 25, 20, 15, 10, 5, 0]
            chart.xLabelsFormatter = { String(Int(round(30 - $1))) + "d" }
            view.addSubview(chart)
            
            let imageView = UIImageView(frame: CGRect(x: view.frame.size.width/2 - imageSize/2, y: 100 + chartHeight + spacing, width: imageSize, height: imageSize))
            imageView.image = coin.image
            view.addSubview(imageView)
            
            priceLabel.frame = CGRect(x: 0, y: 100 + chartHeight + spacing + imageSize + spacing, width: view.frame.size.width, height: lableHeight)
            priceLabel.textAlignment = .center
            view.addSubview(priceLabel)
            
            let yourOwnLableYPos = ((chartHeight + imageSize) + 32.0 * 2 + lableHeight * 2) + 100
            youOwnLabel.frame = CGRect(x: 0, y: yourOwnLableYPos, width: view.frame.size.width, height: lableHeight)
            
            youOwnLabel.textAlignment = .center
            youOwnLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            view.addSubview(youOwnLabel)
            
            worthLabel.frame = CGRect(x: 0, y: (100 + chartHeight + imageSize + 32.0 * 3 + lableHeight * 3), width: view.frame.size.width, height: lableHeight)
            worthLabel.textAlignment = .center
            worthLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            view.addSubview(worthLabel)
        }
    }
    
    override func viewDidLayoutSubviews() {
        chart.frame = CGRect(x: 16, y: 100, width: view.frame.size.width - spacing, height: chartHeight)
    }
    
    func newHistory() {
        if let coin = coin {
            let series = ChartSeries(coin.historicData)
            series.area = true
            chart.add(series)
        }
    }

    func newPrices() {
        if let coin = coin {
            priceLabel.text = coin.priceAsString()
            worthLabel.text = coin.amountAsString()
            youOwnLabel.text = "You Own: \(coin.amount) \(coin.symbol)"
        }
    }
    
}
